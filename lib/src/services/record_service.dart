import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:weappear_backend/extensions/extensions.dart';
import 'package:weappear_backend/src/models/organization/organization.dart';
import 'package:weappear_backend/src/models/record/record.dart';
import 'package:weappear_backend/src/models/user/user.dart';
import 'package:weappear_backend/src/utils/queu_service.dart';
import 'package:weappear_backend/src/utils/utils.dart';

class RecordService {
  final userQueue = QueueService();

  FutureOr<Response> clockIn(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final organizationId = json['organizationId'] as String?;
        if (organizationId == null) {
          return Response(400, body: 'Missing name');
        }

        final organization = await Organization.generic.byId(organizationId);
        if (organization == null) {
          return Response(400, body: 'Organization not found');
        }

        final user = await User.generic.byObjectId(token.userId);
        if (user == null) {
          return Response(400, body: 'User not found');
        }

        if (!organization.containsUser(token.userId.$oid)) {
          return Response(400, body: 'User is not part of the organization');
        }

        return userQueue.addToQueue<Response>(user.id!.$oid, () async {
          final openRecord = await Record.generic.findOpenRecord(
            organizationId: organizationId,
            userId: user.id!.$oid,
          );
          if (openRecord != null) {
            return Response(400, body: 'User already has an open record');
          }

          final clockIn = Record(
            userId: user.id!,
            organizationId: ObjectId.parse(organizationId),
            clockIn: Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          );

          final saveRecord = await clockIn.save();
          if (saveRecord.isFailure) {
            return Response(400, body: 'Failed to save record');
          }

          return Response(200, body: jsonEncode(clockIn.toJsonResponse));
        });
      } catch (e) {
        return Response(500, body: 'Could not create record');
      }
    });
  }

  FutureOr<Response> clockOut(Request request) async {
    return responseHandler(() async {
      try {
        final json = jsonDecode(await request.readAsString()) as Map;

        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final organizationId = json['organizationId'] as String?;
        if (organizationId == null) {
          return Response(400, body: 'Missing name');
        }

        final organization = await Organization.generic.byId(organizationId);
        if (organization == null) {
          return Response(400, body: 'Organization not found');
        }

        final user = await User.generic.byObjectId(token.userId);
        if (user == null) {
          return Response(400, body: 'User not found');
        }

        if (!organization.containsUser(token.userId.$oid)) {
          return Response(400, body: 'User is not part of the organization');
        }

        return userQueue.addToQueue<Response>(user.id!.$oid, () async {
          final openRecord = await Record.generic.findOpenRecord(
            organizationId: organizationId,
            userId: user.id!.$oid,
          );
          if (openRecord == null) {
            return Response(400, body: 'User does not have an open record');
          }

          try {
            final saveRecord = await openRecord.clockOutRecord();
            return Response(200, body: jsonEncode(saveRecord.toJsonResponse));
          } catch (e) {
            return Response(400, body: 'Failed to save record');
          }
        });
      } catch (e) {
        return Response(500, body: 'Could not create record');
      }
    });
  }
}
