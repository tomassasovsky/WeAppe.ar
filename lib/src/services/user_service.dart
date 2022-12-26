// ignore_for_file: avoid_catching_errors

import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:weappear_backend/extensions/extensions.dart';
import 'package:weappear_backend/src/models/user/refresh_token.dart';
import 'package:weappear_backend/src/models/user/user.dart';
import 'package:weappear_backend/src/models/user/user_activation.dart';
import 'package:weappear_backend/src/utils/email_sender.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template user_service}
/// This service has all the methods for the users collection.
/// {@endtemplate}
class UserService {
  /// This method sends an email to the user with a link to verify his email.
  FutureOr<Response> register(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final email = json['email'] as String?;
        if (email == null) {
          return Response(400, body: 'Missing email');
        } else if (!Validators.emailRegExp.hasMatch(email)) {
          return Response(400, body: 'Invalid email');
        }

        final databaseRecords = await Future.wait([
          User.generic.findOne(
            where.eq('email', email),
          ),
          UserActivation.generic.findOne(where.eq('email', email)),
        ]);

        final userInDatabase = databaseRecords.first as User?;
        if (userInDatabase != null) {
          return Response(400, body: 'User with this email already exists');
        }

        final userActivationInDatabase =
            databaseRecords.last as UserActivation?;
        if (userActivationInDatabase != null) {
          await userActivationInDatabase.delete();
        }

        final userActivation = UserActivation(
          activationCode: EmailSenderService.createOtp(),
          email: email,
          createdAt: Timestamp(),
        );

        final activationResult = await userActivation.save();
        if (activationResult.isFailure) {
          return Response(500, body: 'Could not create user activation');
        }

        final emailSent =
            await EmailSenderService().sendRegisterVerificationEmail(
          to: email,
          activationCode: userActivation.activationCode,
        );

        if (!emailSent) {
          return Response(
            500,
            body: 'Could not send verification email',
          );
        }

        return Response.ok('email sent');
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  /// This method verifies the user's email.
  FutureOr<Response> verifyEmail(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final activationCode = json['activationCode'] as String?;
        if (activationCode == null) {
          return Response(400, body: 'Missing activationCode');
        }

        final email = json['email'] as String?;
        if (email == null) {
          return Response(400, body: 'Missing email');
        }

        final userActivation = await UserActivation.generic.findOne(
          where.eq('activationCode', activationCode).eq('email', email),
        );
        if (userActivation == null) {
          return Response(400, body: 'Invalid activationCode or email');
        }

        if (userActivation.createdAt.toDateTime().isBefore(
              DateTime.now().subtract(
                const Duration(minutes: 15),
              ),
            )) {
          return Response(400, body: 'Activation code expired');
        }

        userActivation.verified = true;

        final saveResult = await userActivation.save();
        if (saveResult.isFailure) {
          return Response(500, body: 'Could not verify email');
        }

        return Response.ok(jsonEncode(userActivation.toJsonResponse));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  /// This method creates a new user with the given name and passwords.
  FutureOr<Response> activateUser(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final activationId = json['activationId'] as String?;
        if (activationId == null) {
          return Response(400, body: 'Missing activationCode');
        }

        final email = json['email'] as String?;
        if (email == null) {
          return Response(400, body: 'Missing email');
        }

        final userActivation = await UserActivation.generic.byId(activationId);
        if (userActivation == null || userActivation.email != email) {
          return Response(400, body: 'Invalid activationCode or email');
        }

        if (!userActivation.verified) {
          return Response(400, body: 'Email not verified');
        }

        if (userActivation.createdAt
            .toDateTime()
            .isBefore(DateTime.now().subtract(const Duration(minutes: 15)))) {
          return Response(400, body: 'Activation code expired');
        }

        final password = json['password'] as String?;
        if (password == null) {
          return Response(400, body: 'Missing password');
        } else if (!Validators.passwordRegExp.hasMatch(password)) {
          return Response(400, body: 'Invalid password');
        }

        final firstName = json['firstName'] as String?;
        if (firstName == null) {
          return Response(400, body: 'Missing firstName');
        } else if (firstName.length > 25) {
          return Response(400, body: 'Invalid firstName');
        }

        final lastName = json['lastName'] as String?;
        if (lastName == null) {
          return Response(400, body: 'Missing lastName');
        } else if (lastName.length > 25) {
          return Response(400, body: 'Invalid lastname');
        }

        final user = User(
          email: email,
          password: DBCrypt().hashpw(password, DBCrypt().gensalt()),
          firstName: firstName,
          lastName: lastName,
          activationDate: Timestamp(),
        );

        final result = await user.save();
        if (result.isFailure) {
          return Response(500, body: 'Could not activate user');
        }

        await userActivation.delete();

        return Response.ok(jsonEncode(user.toJsonResponse));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  /// This method allows users to login.
  FutureOr<Response> login(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final email = json['email'] as String?;
        if (email == null) {
          return Response(400, body: 'Missing email');
        }

        final password = json['password'] as String?;
        if (password == null) {
          return Response(400, body: 'Missing password');
        }

        final user = await User.generic.findOne(where.eq('email', email));
        if (user == null) {
          return Response(400, body: 'Invalid email or password');
        }

        final correctPassword = DBCrypt().checkpw(password, user.password!);
        if (!correctPassword) {
          return Response(400, body: 'Invalid email or password');
        }

        final refreshToken = JWT(
          {'userId': user.id?.$oid},
          issuer: 'https://weappe.ar',
        ).sign(
          SecretKey(Constants.jwtRefreshSignature),
          expiresIn: const Duration(days: 90),
        );

        // save the refresh token in the database:
        final refTokenResult = await RefreshToken.generic.insertOne(
          <String, dynamic>{
            'userId': user.id,
            'refreshToken': refreshToken,
          },
        );

        if (refTokenResult.isFailure) {
          return Response(500, body: 'Could not create refresh token');
        }

        final accessToken = JWT(
          {
            'userId': user.id?.$oid,
            'refreshTokenId': (refTokenResult.id as ObjectId?)?.$oid,
          },
          issuer: 'https://weappe.ar',
        ).sign(
          SecretKey(Constants.jwtAccessSignature),
          expiresIn: const Duration(days: 7),
        );

        final responseMap = {
          'user': user.toJsonResponse,
          'refreshToken': refreshToken,
          'accessToken': accessToken,
        };

        return Response.ok(jsonEncode(responseMap));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  /// This method refreshes the access token.
  FutureOr<Response> regenerateAccessToken(Request request) async {
    return responseHandler(() async {
      final token = request.token;

      if ((token?.isEmpty ?? true) ||
          token?.toLowerCase() == 'null' ||
          token == null) {
        return Response(
          401,
          body: {
            'message': 'Missing token',
          },
        );
      }

      final tokenIsValid = token.isValid;
      if (tokenIsValid != null) {
        return tokenIsValid;
      }

      final refreshTokenDb = await RefreshToken.generic.findOne(
        where.eq('refreshToken', token),
      );

      if (refreshTokenDb == null || !refreshTokenDb.isValid) {
        return Response(
          401,
          body: {
            'message': 'Invalid token',
          },
        );
      }

      final user = await User.generic.findOne(
        where.id(refreshTokenDb.userId),
      );

      if (user == null) {
        return Response(
          401,
          body: {
            'message': 'User not found',
          },
        );
      }

      final newAccessToken = JWT(
        {
          'userId': refreshTokenDb.userId.$oid,
          'refreshTokenId': refreshTokenDb.id?.$oid,
        },
        issuer: 'https://weappe.ar',
      ).sign(
        SecretKey(Constants.jwtAccessSignature),
        expiresIn: const Duration(days: 7),
      );

      return Response.ok({
        'accessToken': newAccessToken,
      });
    });
  }

  /// This method allows users to update their personal information.
  FutureOr<Response> updateInfo(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;
        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final user = await User.generic.byObjectId(token.userId);
        if (user == null) {
          return Response(401, body: 'User not found');
        }

        final password = json['password'] as String?;
        if (password == null) {
          return Response(400, body: 'Missing password');
        } else if (!Validators.passwordRegExp.hasMatch(password)) {
          return Response(400, body: 'Invalid password');
        } else if (DBCrypt().checkpw(password, user.password!) == false) {
          return Response(400, body: 'Invalid password');
        }

        final description = json['description'] as String?;
        final location = json['location'] as String?;
        final photo = json['photo'] as String?;
        final gender = Gender.fromString(
          json['gender'] as String? ?? user.gender.name,
        );
        final timezone = json['timezone'] as String?;
        if (timezone != null) {
          try {
            tz.getLocation(timezone);
          } catch (e) {
            return Response(400, body: 'Invalid location');
          }
        }
        final lang = json['lang'] as String?;
        if (lang != null && !languageByLocale.containsKey(lang)) {
          return Response(400, body: 'Invalid localization');
        }

        final saveUser = user.copyWith(
          description: description,
          location: location,
          gender: gender,
          imageUrl: photo,
          lang: lang,
          timezone: timezone,
        );

        final result = await saveUser.save();

        if (result.isFailure && !result.isSuccess) {
          return Response(500, body: 'Could not save changes');
        }

        return Response.ok(jsonEncode(saveUser.toJsonResponse));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  /// This method allows users to update their password.
  FutureOr<Response> updatePassword(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;
        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final user = await User.generic.byObjectId(token.userId);
        if (user == null) {
          return Response(401, body: 'User not found');
        }

        final oldPassword = json['oldPassword'] as String?;
        if (oldPassword == null) {
          return Response(400, body: 'Missing password');
        } else if (!Validators.passwordRegExp.hasMatch(oldPassword)) {
          return Response(400, body: 'Invalid password');
        } else if (DBCrypt().checkpw(oldPassword, user.password!) == false) {
          return Response(400, body: 'Invalid password');
        }

        final newPassword = json['newPassword'] as String?;
        if (newPassword == null) {
          return Response(400, body: 'Missing new password');
        } else if (!Validators.passwordRegExp.hasMatch(newPassword)) {
          return Response(400, body: 'Invalid new password');
        }

        final hashedPassword =
            DBCrypt().hashpw(newPassword, DBCrypt().gensalt());

        final saveUser = user.copyWith(password: hashedPassword);

        final result = await saveUser.save();

        if (result.isFailure && !result.isSuccess) {
          return Response(500, body: 'Could not change password');
        }

        return Response.ok(jsonEncode(saveUser.toJsonResponse));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }
}
