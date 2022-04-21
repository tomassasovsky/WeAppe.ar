part of 'clock_in.dart';

class ClockInController extends Controller {
  late final ObjectId userId;
  late final String organizationId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    userId = req.store.get<ObjectId>('userId');
    organizationId = req.store.get<String>('organizationId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final clockIn = ClockInOut(
      userId: userId,
      organizationId: ObjectId.parse(organizationId),
      clockIn: DateTime.now(),
    );

    final result = await Services().clockInOuts.clockIn(clockIn);

    if (result.failure) {
      throw AlfredException(500, {
        'message': 'clockIn failed',
      });
    }

    res.statusCode = 200;
    await res.json(clockIn.toJson());
  }
}
