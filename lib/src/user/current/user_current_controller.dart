part of 'current.dart';

@reflector
class UserCurrentController extends Controller {
  late final User user;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    user = req.store.get<User>('user');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    res.statusCode = 200;
    await res.json(
      user.toJson(showPassword: false),
    );
  }
}
