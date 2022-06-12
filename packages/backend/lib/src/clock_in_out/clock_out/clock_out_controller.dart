part of 'clock_out.dart';

class ClockOutController extends Controller<ClockOutController> {
  late final LoggedTime loggedTime;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    loggedTime = req.store.get<LoggedTime>('loggedTime');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final result = await loggedTime.clockOut();

    if (result.isFailure) {
      res.reasonPhrase = 'clockOutFailed';
      throw AlfredException(500, {
        'message': 'clockOut failed',
      });
    }

    res.statusCode = 200;
    await res.json(
      loggedTime.toJson(standardEncoding: true),
    );
  }

  @override
  ClockOutController get newInstance => ClockOutController();
}
