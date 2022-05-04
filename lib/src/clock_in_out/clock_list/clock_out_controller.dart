part of 'clock_out.dart';

class ClockListController {
  const ClockListController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final clockInOuts =
        req.store.get<List<Map<String, dynamic>>>('clockInOuts');

    res.statusCode = 200;
    await res.json(
      <String, dynamic>{
        'clockInOuts': clockInOuts,
      },
    );
  }
}
