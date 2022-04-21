part of 'current.dart';

class UserCurrentController {
  const UserCurrentController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final user = req.store.get<User>('user');

    res.statusCode = 200;
    await res.json(
      user.toJson(showPassword: false),
    );
  }
}
