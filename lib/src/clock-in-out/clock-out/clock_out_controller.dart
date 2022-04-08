part of 'clock_out.dart';

class ClockOutController {
  const ClockOutController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final clockInOutId = req.store.get<String>('clockInOutId');

    final clockIn = await services.clockInOuts.findClockInById(clockInOutId);

    if (clockIn == null) {
      throw AlfredException(401, {
        'message': 'clock in not found',
      });
    }

    try {
      await services.clockInOuts.clockOut(clockInOutId);
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
