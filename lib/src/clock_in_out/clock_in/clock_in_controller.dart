part of 'clock_in.dart';

@reflector
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
      clockIn: Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000),
    );

    final result = await Services().clockInOuts.clockIn(clockIn);

    if (result.isFailure) {
      throw AlfredException(403, {
        'message': 'clockIn failed! maybe you have a clock in open?',
      });
    }

    res.statusCode = 200;
    await res.json(clockIn.toJson(standardEncoding: true));
  }
}
