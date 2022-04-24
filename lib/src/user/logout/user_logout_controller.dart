part of 'logout.dart';

@reflector
class UserLogoutController extends Controller {
  late final String token;
  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    token = req.store.get<String>('token');
  }

  @override
  FutureOr<void> run(HttpRequest req, HttpResponse res) async {
    final result = await Services().tokens.deleteFromDatabase(token);

    if (result.isFailure) {
      res
        ..statusCode = HttpStatus.internalServerError
        ..write(result.errmsg);
      return;
    }

    res.statusCode = HttpStatus.ok;
    await res.close();
  }
}
