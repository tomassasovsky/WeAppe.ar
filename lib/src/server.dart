import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/src/clock_in_out/clock_in_out.dart';
import 'package:backend/src/invite/send_invite/send_invite.dart';
import 'package:backend/src/organization/organization.dart';
import 'package:backend/src/user/user.dart';
import 'package:backend/src/validators/validators.dart';

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
          UserRegisterMiddleware(),
        ],
      )
      ..put(
        'user/update',
        UserUpdateController(),
        middleware: [
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
          CreateOrganizationMiddleware(),
        ],
      )
      ..put(
        'organization/:id:[0-9a-z]+',
        UpdateOrganizationController(),
        middleware: [
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
          AuthenticationMiddleware(),
          InviteCreateMiddleware(),
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
