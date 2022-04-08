import 'package:backend/src/clock-in-out/models/clock_in_out.dart';
import 'package:backend/src/database/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ClockInOutService {
  ClockInOutService(this.dbService);
  final DatabaseService dbService;

  Future<ClockInOut?> findClockInById(
    String id,
  ) async {
    final clockIn = await dbService.clockInOutCollection
        .findOne(where.id(ObjectId.parse(id)));

    if (clockIn == null || clockIn.isEmpty) {
      return null;
    }

    return ClockInOut.fromJson(clockIn);
  }

  Future<WriteResult> clockIn(
    ClockInOut clockIn,
  ) async {
    return dbService.clockInOutCollection.insertOne(clockIn.toJson());
  }

  Future<void> clockOut(
    String id,
  ) async {
    await dbService.clockInOutCollection.updateOne(
      where.id(ObjectId.parse(id)),
      modify.set('clockOut', DateTime.now()),
    );
  }
}
