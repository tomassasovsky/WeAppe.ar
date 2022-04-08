part of 'clock_out.dart';

class ClockOutController {
  const ClockOutController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final clockInOut = req.store.get<ClockInOut>('clockInOut');

    final result = await services.clockInOuts.clockOut(clockInOut.id!);
    final document = result.document;

    if (result.isFailure || document == null) {
      res.reasonPhrase = 'clockOutFailed';
      throw AlfredException(500, {
        'message': 'clockOut failed',
      });
    }

    final newClockInOut = ClockInOut.fromJson(
      document.cast<String, dynamic>(),
    );

    res.statusCode = 200;
    await res.json(
      newClockInOut.toJson(),
    );
  }
}
