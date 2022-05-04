import 'package:alfred/alfred.dart';

class TestController {
  const TestController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    res.statusCode = 200;
    await res.json(
      <String, dynamic>{
        'clockInOuts': 'Messi',
      },
    );
  }
}
