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

    try {
      final result = await services.clockInOuts.clockIn(clockIn);
      res.statusCode = 200;
      await res.json(
        <String, dynamic>{
          'id': result.id,
          ...clockIn.toJson(),
        },
      );
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
