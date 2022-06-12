part of 'clock_in.dart';

class ClockInController extends Controller<ClockInController> {
  late final ObjectId userId;
  late final ObjectId organizationId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    userId = req.store.get<ObjectId>('userId');
    organizationId = req.store.get<ObjectId>('organizationId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final loggedTime = LoggedTime();

    final result = await loggedTime.clockIn(
      userId: userId,
      organizationId: organizationId,
    );

    if (result.isFailure) {
      throw AlfredException(403, {
        'message': 'clockIn failed! maybe you have a clock in open?',
      });
    }

    res.statusCode = 200;
    await res.json(
      loggedTime.toJson(
        standardEncoding: true,
      ),
    );
  }

  @override
  ClockInController get newInstance => ClockInController();
}
