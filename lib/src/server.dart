import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/src/user/user.dart';

class Server {
  const Server();

  Future<void> init() async {
    // initialize alfred:
    final app = Alfred(
      onNotFound: (req, res) => throw AlfredException(404, {'message': '${req.requestedUri.path} not found'}),
      onInternalError: errorHandler,
    )
      ..post(
        'user/register',
        const UserRegisterController(),
        middleware: [const UserRegisterMiddleware()],
      )
      ..put(
        'user/update',
        const UserUpdateController(),
        middleware: [const UserUpdateMiddleware()],
      )
      ..post(
        'user/login',
        const UserLoginController(),
        middleware: [
          const UserLoginMiddleware(),
        ],
      )
      ..printRoutes();

    // start the alfred server:
    await app.listen(8080);
  }
}

FutureOr<dynamic> errorHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = 500;
  return {'message': 'error not handled'};
}
