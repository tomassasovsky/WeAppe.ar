part of 'logout.dart';

class UserLogoutController {
  const UserLogoutController();

  Future<void> call(HttpRequest req, HttpResponse res) async {
    final token = req.store.get<String>('token');

    final result = await services.tokens.deleteFromDatabase(token);

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
