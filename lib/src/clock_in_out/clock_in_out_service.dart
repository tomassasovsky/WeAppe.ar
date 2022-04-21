import 'package:backend/src/clock_in_out/clock_in_out.dart';
import 'package:backend/src/database/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ClockInOutService {
  ClockInOutService(this.dbService);
  final DatabaseService dbService;

  Future<ClockInOut?> findClockInById(
    ObjectId id,
  ) async {
    final clockIn = await dbService.clockInOutCollection.findOne(where.id(id));

    if (clockIn == null || clockIn.isEmpty) {
      return null;
    }

    return ClockInOut.fromJson(clockIn);
  }

  Future<ClockInOut?> findLastClockIn({
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

  Future<WriteResult> clockIn(
    ClockInOut clockIn,
  ) async {
    return dbService.clockInOutCollection.insertOne(clockIn.toJson());
  }

  Future<WriteResult> clockOut(
    ObjectId id,
  ) async {
    final date = DateTime.now();
    final clockIn = await findClockInById(id);
    final duration = date.difference(clockIn!.clockIn);
    final result = await dbService.clockInOutCollection.updateOne(
      where.id(id),
      modify
        ..set('clockOut', date.toIso8601String())
        ..set('durationInMiliseconds', duration.inMilliseconds),
    );
    result.document = <String, dynamic>{
      ...clockIn.toJson(),
      'clockOut': date.toIso8601String(),
      'durationInMiliseconds': duration.inMilliseconds,
    };
    return result;
  }
}
