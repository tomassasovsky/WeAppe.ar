import 'package:backend/src/clock-in-out/models/clock_in_out.dart';
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
    required ObjectId organizationId,
    required ObjectId userId,
  }) async {
    final clockIn = await dbService.clockInOutCollection.findOne(
      where
          .eq('organizationId', organizationId)
          .eq('userId', userId)
          .sortBy('clockIn', descending: true),
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

  Future<ClockInOut?> clockOut(
    ObjectId id,
  ) async {
    final date = DateTime.now();
    final clockIn = await findClockInById(id);
    final duration = date.difference(clockIn!.clockIn);
    await dbService.clockInOutCollection.updateOne(
      where.id(id),
      modify
          .set('clockOut', date.toIso8601String())
          .set('durationInMiliseconds', duration.inMilliseconds),
    );
    return findClockInById(id);
  }
}
