import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:alfredito/alfredito.dart';
import 'package:backend/backend.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ClockInOutService {
  ClockInOutService(this.dbService);

  final DatabaseService dbService;
  final userQueue = QueueService();

  FutureOr<ClockInOut?> findClockInById(
    ObjectId id,
  ) async {
    final clockIn = await dbService.clockInOutCollection.findOne(where.id(id));

    if (clockIn == null || clockIn.isEmpty) {
      return null;
    }

    return ClockInOut.fromJson(clockIn);
  }

  FutureOr<ClockInOut?> findLastClockIn({
    required dynamic organizationId,
    required dynamic userId,
  }) async {
    final _userId =
        (userId is ObjectId) ? userId : ObjectId.parse(userId as String);
    final _organizationId = (organizationId is ObjectId)
        ? organizationId
        : ObjectId.parse(organizationId as String);

    final clockIn = await dbService.clockInOutCollection.findOne(
      where
        ..eq('organizationId', _organizationId)
        ..eq('userId', _userId)
        ..sortBy('clockIn', descending: true),
    );

    if (clockIn == null) {
      return null;
    }

    return ClockInOut.fromJson(clockIn);
  }

  FutureOr<List<ClockInOut>?> getListByUserId({
    required dynamic userId,
    required int qty,
    required Timestamp from,
    required Timestamp to,
    dynamic organizationId,
  }) async {
    ObjectId? _organizationId;

    final _userId =
        (userId is ObjectId) ? userId : ObjectId.parse(userId as String);

    final selector = where
      ..eq('userId', _userId)
      ..gte('clockIn', from)
      ..lte('clockOut', to)
      ..sortBy('clockIn', descending: true)
      ..limit(qty);

    if (organizationId != null) {
      _organizationId = (organizationId is ObjectId)
          ? organizationId
          : ObjectId.parse(organizationId as String);
      selector..eq('organizationId', _organizationId);
    }

    final clockList =
        await dbService.clockInOutCollection.find(selector).toList();

    if (clockList.isEmpty) {
      return null;
    }

    return clockList.map(ClockInOut.fromJson).toList();
  }

  FutureOr<WriteResult> clockOut(
    ObjectId id,
  ) async {
    final date = Timestamp();
    final clockIn = await findClockInById(id);
    final duration = date.seconds - (clockIn?.clockIn.seconds ?? 0);
    final result = await dbService.clockInOutCollection.updateOne(
      where.id(id),
      modify
        ..set('clockOut', date)
        ..set('durationInMiliseconds', duration * 1000),
    );
    result.document = <String, dynamic>{
      ...clockIn?.toJson() ?? <String, dynamic>{},
      'clockOut': date,
      'durationInMiliseconds': duration * 1000,
    };
    return result;
  }

  Future<WriteResult> clockIn(
    ClockInOut clockInOut,
  ) async {
    return userQueue.addToQueue(clockInOut.userId, () async {
      final clockInQuery = await findLastClockIn(
        organizationId: clockInOut.organizationId,
        userId: clockInOut.userId,
      );

      if (clockInQuery != null && clockInQuery.clockOut == null) {
        throw AlfredException(409, {
          'message': 'you have a clock in open!',
        });
      }

      final result = await dbService.clockInOutCollection.insertOne(
        clockInOut.toJson(),
      );
      return result;
    });
  }
}
