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

/// {@template record_service}
/// This service has all the methods for the records collection.
/// {@endtemplate}
class RecordService {
  /// This queu is used to prevent multiple clock in and clock out requests.
  final userQueue = QueueService();

  /// This method creates a new record.
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
          return Response(400, body: 'Missing organizationId');
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

  /// This method closes an open record.
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
          return Response(400, body: 'Missing organizationId');
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

  /// This method returns all records an user made in an organization.
  FutureOr<Response> getRecords(Request request) async {
    return responseHandler(() async {
      try {
        final queryParams = request.url.queryParameters;
        final column = queryParams['column'] ?? 'clockIn';
        final limit = int.parse(queryParams['limit'] ?? '50');
        final start = int.parse(queryParams['start'] ?? '0');
        var direction = true;
        if (queryParams['direction']?.toLowerCase() == 'asc') {
          direction = false;
        }

        final token = JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );

        final organizationId = queryParams['organizationId'];
        if (organizationId == null) {
          return Response(400, body: 'Missing organizationId');
        }

        final organization = await Organization.generic.byId(organizationId);
        if (organization == null) {
          return Response(400, body: 'Organization not found');
        }

        if (!organization.containsUser(token.userId.$oid)) {
          return Response(400, body: 'User is not part of the organization');
        }

        final query = where
            .eq('userId', token.userId.$oid)
            .eq('organizationId', organizationId);

        final recods = await Record.generic.find(
          query
              .sortBy(
                column,
                descending: direction,
              )
              .skip(start),
        );
        final total = await Record.generic.count(query);

        return Response.ok(
          jsonEncode(<String, dynamic>{
            'meta': {
              'total': total,
              'returned': recods.length,
              'offset': start,
              'limit': limit,
            },
            'items': recods.map((e) => e.toJsonResponse).toList(),
          }),
        );
      } catch (e) {
        return Response(500, body: 'Could not get records');
      }
    });
  }

  /// This method is used to create a new record with the given hours, thus
  /// allowing for quick clock in and clock out.
  FutureOr<Response> createRecord(Request request) async {
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

        if (!organization.containsUser(token.userId.$oid)) {
          return Response(400, body: 'User is not part of the organization');
        }

        final hoursString = json['hours'] as String?;
        if (hoursString == null) {
          return Response(400, body: 'Missing hours');
        }

        final hours = int.parse(hoursString);

        if (hours <= 0 || hours >= 24) {
          return Response(400, body: 'Invalid hours');
        }

        final user = await User.generic.byObjectId(token.userId);
        if (user == null) {
          return Response(400, body: 'User not found');
        }

        final now = DateTime.now();
        var remainingHours = 0;
        var lastHour = 9 + hours;
        if (lastHour > 24) {
          remainingHours = lastHour - 24;
          lastHour = 24;
        }
        final firstHour = 9 - remainingHours;

        final record = Record(
          userId: token.userId,
          organizationId: organization.id!,
          clockIn: DateTime(
            now.year,
            now.month,
            now.day,
            firstHour,
          ).toTimestamp(),
          clockOut: DateTime(
            now.year,
            now.month,
            now.day,
            lastHour,
          ).toTimestamp(),
          durationInMiliseconds: Duration(
            hours: hours,
          ).inMilliseconds,
        );

        final saveRecord = await record.save();
        if (saveRecord.isFailure) {
          return Response(400, body: 'Failed to save record');
        }

        return Response.ok(jsonEncode(record.toJsonResponse));
      } catch (_) {
        return Response(400, body: 'Could not create record');
      }
    });
  }
}
