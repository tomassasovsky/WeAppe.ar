import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';

class Server {
  const Server();

  FutureOr<void> init() async {
    // initialize alfred:
    final app = Alfred(
      onNotFound: (req, res) => throw AlfredException(
        404,
        {'message': '${req.requestedUri.path} not found'},
      ),
      onInternalError: errorHandler,
    )
      ..post(
        'user/register',
        UserRegisterController(),
        middleware: [
          AuthenticationMiddleware(),
          UserRegisterMiddleware(),
        ],
      )
      ..put(
        'user/update',
        UserUpdateController(),
        middleware: [
          AuthenticationMiddleware(),
          UserUpdateMiddleware(),
        ],
      )
      ..post(
        'user/login',
        UserLoginController(),
        middleware: [
          UserLoginMiddleware(),
        ],
      )
      ..get(
        'user',
        UserCurrentController(),
        middleware: [
          AuthenticationMiddleware(),
        ],
      )
      ..post(
        'organization',
        CreateOrganizationController(),
        middleware: [
          AuthenticationMiddleware(),
          CreateOrganizationMiddleware(),
        ],
      )
      ..put(
        'organization/:id:[0-9a-z]+',
        UpdateOrganizationController(),
        middleware: [
          AuthenticationMiddleware(),
          UpdateOrganizationMiddleware(),
        ],
      )
      ..post(
        'organization/join/:refId:uuid',
        JoinOrganizationController(),
        middleware: [
          AuthenticationMiddleware(),
          JoinOrganizationMiddleware(),
        ],
      )
      ..delete(
        'user/logout',
        UserLogoutController(),
        middleware: [
          AuthenticationMiddleware(),
        ],
      )
      ..post(
        'clock/in/:id:[0-9a-z]+',
        ClockInController(),
        middleware: [
          AuthenticationMiddleware(),
          ClockInMiddleware(),
        ],
      )
      ..post(
        'clock/out/:id:[0-9a-z]+',
        ClockOutController(),
        middleware: [
          AuthenticationMiddleware(),
          ClockOutMiddleware(),
        ],
      )
      ..post(
        'invite/send/',
        InviteCreateController(),
        middleware: [
          (req, res) => AuthenticationMiddleware().call,
          (req, res) => InviteCreateMiddleware().call,
        ],
      )
      ..printRoutes()
      ..registerOnDoneListener(errorPluginOnDoneHandler);

    // start the alfred server:
    await app.listen(8080);
  }
}

FutureOr<dynamic> errorHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = 500;
  return {'message': 'error not handled'};
}
