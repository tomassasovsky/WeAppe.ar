part of 'current.dart';

class UserCurrentController {
  const UserCurrentController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    return req.store.get<User>('user');
  }
}
