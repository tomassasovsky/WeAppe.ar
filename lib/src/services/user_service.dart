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

class UserService {
  FutureOr<Response> register(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final firstName = json['firstName'] as String?;
        if (firstName == null) {
          return Response(400, body: 'Missing firstName');
        }

        final lastName = json['lastName'] as String?;
        if (lastName == null) {
          return Response(400, body: 'Missing lastName');
        }

        final email = json['email'] as String?;
        if (email == null) {
          return Response(400, body: 'Missing email');
        } else if (!Validators.emailRegExp.hasMatch(email)) {
          return Response(400, body: 'Invalid email');
        }

        final password = json['password'] as String?;
        if (password == null) {
          return Response(400, body: 'Missing password');
        } else if (!Validators.passwordRegExp.hasMatch(password)) {
          return Response(400, body: 'Invalid password');
        }

        final hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());
        final user = User(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: hashedPassword,
        );

        final result = await user.save();

        if (result.isFailure) {
          return Response(500, body: 'Could not create user');
        }

        final userActivation = UserActivation(
          activationKey: Uuid().v4(),
          userId: user.id!,
        );

        final activationResult = await userActivation.save();
        if (activationResult.isFailure) {
          return Response(500, body: 'Could not create user activation');
        }

        final emailSent =
            await EmailSenderService().sendRegisterVerificationEmail(
          to: user.email,
          activationKey: userActivation.activationKey,
        );

        if (!emailSent) {
          return Response(500, body: 'Could not send verification email');
        }

        return Response.ok(jsonEncode(user.toJsonResponse));
      } catch (_) {
        return Response(500, body: 'Unknown error');
      }
    });
  }

  FutureOr<Response> activateUser(
    Request request,
    String? activationKey,
  ) async {
    return responseHandler(() async {
      try {
        if (activationKey == null) {
          return Response(400, body: 'Missing activationKey');
        }

        final userActivation = await UserActivation.generic.findOne(
          where.eq('activationKey', activationKey),
        );
        if (userActivation == null) {
          return Response(400, body: 'Invalid activationKey');
        }

        final user =
            await User.generic.findOne(where.id(userActivation.userId));
        if (user == null) {
          return Response(400, body: 'Invalid activationKey');
        }

        final result = await user.activate();
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
        final refTokenResult = await RefreshTokenDB.generic.insertOne(
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

  FutureOr<Response> regenerateAccessToken(Request request) async {
    return responseHandler(() async {
      final token = request.token;

      if ((token?.isEmpty ?? true) ||
          token?.toLowerCase() == 'null' ||
          token == null) {
        return Response(401, body: {
          'message': 'Missing token',
        });
      }

      try {
        JWT.verify(
          token,
          SecretKey(Constants.jwtRefreshSignature),
        );
      } on JWTError {
        return Response(401, body: {
          'message': 'Invalid token',
        });
      } on FormatException {
        return Response(401, body: {
          'message': 'Invalid token',
        });
      }

      final refreshTokenDb = await RefreshTokenDB.generic.findOne(
        where.eq('refreshToken', token),
      );

      if (refreshTokenDb == null || !refreshTokenDb.isValid) {
        return Response(401, body: {
          'message': 'Invalid token',
        });
      }

      final user = await User.generic.findOne(
        where.id(refreshTokenDb.userId),
      );

      if (user == null) {
        return Response(401, body: {
          'message': 'User not found',
        });
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
        if (lang != null && !LANGUAGE_BY_LOCALE.containsKey(lang)) {
          return Response(400, body: 'Invalid localization');
        }

        final saveUser = user.copyWith(
          description: description,
          location: location,
          gender: gender,
          photo: photo,
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
