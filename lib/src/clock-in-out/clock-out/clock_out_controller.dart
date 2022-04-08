part of 'clock_out.dart';

class ClockOutController {
  const ClockOutController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final clockInOut = req.store.get<ClockInOut>('clockInOut');

    final newClockInOut = await services.clockInOuts.clockOut(clockInOut.id!);

    res.statusCode = 200;
    await res.json(
      newClockInOut!.toJson(),
    );
  }
}
