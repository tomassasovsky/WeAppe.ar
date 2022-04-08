part of 'clock_in.dart';

class ClockInController {
  const ClockInController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final user = req.store.get<User>('user');
    final organizationId = req.store.get<ObjectId>('organizationId');

    final clockIn = ClockInOut(
      userId: user.id!,
      organizationId: organizationId,
      clockIn: DateTime.now(),
    );

    await services.clockInOuts.clockIn(clockIn);
    res.statusCode = 200;
    await res.json(
      clockIn.toJson(),
    );
  }
}
