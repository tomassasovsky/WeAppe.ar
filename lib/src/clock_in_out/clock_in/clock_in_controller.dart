part of 'clock_in.dart';

class ClockInController {
  const ClockInController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final userId = req.store.get<User>('user').id;
    final organizationId = req.store.get<String>('organizationId');

    if (userId == null) {
      throw AlfredException(500, {
        'message': 'userId is null',
      });
    }

    final clockIn = ClockInOut(
      userId: userId,
      organizationId: ObjectId.parse(organizationId),
      clockIn: DateTime.now(),
    );

    final result = await services.clockInOuts.clockIn(clockIn);

    if (result.failure) {
      throw AlfredException(500, {
        'message': 'clockIn failed',
      });
    }

    res.statusCode = 200;
    await res.json(clockIn.toJson());
  }
}
