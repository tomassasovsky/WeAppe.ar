import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/src/clock-in-out/clock-in/clock_in.dart';
import 'package:backend/src/clock-in-out/clock-out/clock_out.dart';
import 'package:backend/src/organization/create_organization/create_organization.dart';
import 'package:backend/src/user/current/current.dart';
import 'package:backend/src/user/user.dart';
import 'package:backend/src/validators/auth_validator.dart';

class Server {
  const Server();

  Future<void> init() async {
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
      ..get(
        'user',
        const UserCurrentController(),
        middleware: [
          const AuthenticationMiddleware(),
        ],
      )
      ..post(
        'organization/create',
        const CreateOrganizationController(),
        middleware: [const CreateOrganizationMiddleware()],
      )
      ..delete(
        'user/logout',
        const UserLogoutController(),
        middleware: [const AuthenticationMiddleware()],
      )
      ..post(
        'clock/in/:id',
        const ClockInController(),
        middleware: [const ClockInMiddleware()],
      )
      ..post(
        'clock/out/:id',
        const ClockOutController(),
        middleware: [const ClockOutMiddleware()],
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
