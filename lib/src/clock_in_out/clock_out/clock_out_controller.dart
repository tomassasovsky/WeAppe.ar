part of 'clock_out.dart';

class ClockOutController extends Controller<ClockOutController> {
  late final ObjectId clockInOutId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    clockInOutId = req.store.get<ObjectId>('clockInOutId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final result = await Services().clockInOuts.clockOut(clockInOutId);
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
      newClockInOut.toJson(standardEncoding: true),
    );
  }

  @override
  ClockOutController get newInstance => ClockOutController();
}
