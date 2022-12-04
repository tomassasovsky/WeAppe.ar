import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:weappear_backend/extensions/extensions.dart';
import 'package:weappear_backend/src/models/organization/invite.dart';
import 'package:weappear_backend/src/models/organization/organization.dart';
import 'package:weappear_backend/src/models/user/user.dart';
import 'package:weappear_backend/src/utils/email_sender.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template organization_service}
/// This service has all the methods for the organizations collection.
/// {@endtemplate}
class OrganizationService {
  /// This method creates a new organization.
  FutureOr<Response> create(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final name = json['name'] as String?;
        if (name == null) {
          return Response(400, body: 'Missing name');
        }

        final color = json['color'] as String?;
        if (color == null) {
          return Response(400, body: 'Color is missing');
        }

        if (!Validators.colorRegExp.hasMatch(color)) {
          return Response(400, body: 'Invalid color');
        }

        final user = await User.generic.findOne(where.id(token.userId));
        if (user == null) {
          return Response(400, body: 'User not found');
        }

        final homePageUrl = json['homePageUrl'] as String?;
        if (homePageUrl != null &&
            !Validators.urlRegExp.hasMatch(homePageUrl)) {
          return Response(400, body: 'Invalid home page url');
        }

        final imageUrl = json['imageUrl'] as String?;
        if (imageUrl != null && !Validators.urlRegExp.hasMatch(imageUrl)) {
          return Response(400, body: 'Invalid image url');
        }

        final organization = Organization(
          name: name,
          admin: token.userId,
          homePageUrl: homePageUrl,
          imageUrl: imageUrl,
          color: color,
        );

        final saveResult = await organization.save();
        if (saveResult.isFailure) {
          return Response(500, body: 'Could not create organization');
        }

        user.organizations ??= [];
        user.organizations?.add(organization.id!);

        final saveUserResult = await user.save();
        if (saveUserResult.isFailure) {
          return Response(500, body: 'Could not create organization');
        }

        return Response.ok(jsonEncode(organization.toJson()));
      } catch (e) {
        return Response(500, body: 'Could not create organization');
      }
    });
  }

  /// This method sends invites to the users.
  FutureOr<Response> sendInviteByMail(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final organizationId = json['organizationId'] as String?;
        if (organizationId == null) {
          return Response(400, body: 'Missing organizationId');
        }

        final userTypeJson = json['userType'] as String?;
        if (userTypeJson == null) {
          return Response(400, body: 'Missing userType');
        }

        UserType userType;
        try {
          userType = UserType.fromString(userTypeJson);
        } catch (e) {
          return Response(400, body: 'Invalid userType');
        }

        final emails = (json['emails'] as List?)?.cast<String>();
        if (emails == null) {
          return Response(400, body: 'Missing emails');
        }

        final users = await Future.wait(
          emails.map(
            (e) => User.generic.findOne(
              where.eq('email', e),
            ),
          ),
        );

        final organization = await Organization.generic.byId(organizationId);
        if (organization == null) {
          return Response(400, body: 'Organization not found');
        }

        if (organization.admin.$oid != token.userId.$oid) {
          return Response(
            403,
            body: 'You are not the admin of this organization',
          );
        }

        final invite = Invite(
          emitter: token.userId,
          refId: const Uuid().v4(),
          organization: organization.id!,
          userType: userType,
        );

        final saveInvite = await invite.save();
        if (saveInvite.isFailure) {
          return Response(500, body: 'Could not send invites');
        }

        final sendEmails = await EmailSenderService().sendInvites(
          users: users,
          organization: organization,
          refId: invite.refId,
        );
        if (!sendEmails) {
          return Response(500, body: 'Could not send invites');
        }

        return Response.ok(jsonEncode(invite.toJsonResponse));
      } catch (e) {
        return Response(500, body: 'Could not create organization');
      }
    });
  }

  /// This method is used to let users join an organizations.
  FutureOr<Response> joinOrganization(
    Request request,
    String refId,
    String userId,
  ) async {
    return responseHandler(() async {
      try {
        final invite = await Invite.generic.findOne(where.eq('refId', refId));
        if (invite == null) {
          return Response(400, body: 'Invite not found');
        }

        if (invite.isExpired) {
          await invite.delete();
          return Response(400, body: 'Invite expired');
        }

        final organization = await Organization.generic.byObjectId(
          invite.organization,
        );
        if (organization == null) {
          return Response(400, body: 'Organization not found');
        }

        if (organization.containsUser(userId)) {
          return Response(400, body: 'You are already in this organization');
        }

        final user = await User.generic.byId(userId);
        if (user == null) {
          return Response(400, body: 'User not found');
        }

        user.organizations ??= [];
        final organizationsId = user.organizations?.map((e) => e.$oid);
        if (organizationsId?.contains(organization.id?.$oid) ?? false) {
          user.organizations?.add(organization.id!);
        }

        final saveUserResult = await user.save();
        if (saveUserResult.isFailure) {
          return Response(500, body: 'Could not join organization');
        }

        if (invite.userType == UserType.employee) {
          organization.employees ??= [];
          organization.employees?.add(user.id!);
        } else {
          organization.employers ??= [];
          organization.employers?.add(user.id!);
        }

        await organization.save();

        return Response.ok(jsonEncode(organization.toJson()));
      } catch (e) {
        return Response(500, body: 'Could not join organization');
      }
    });
  }
}
