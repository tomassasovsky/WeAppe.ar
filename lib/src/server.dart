import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';
import 'package:backend/src/clock_in_out/clock_list/clock_list.dart';

class Server {
  static final Server _instance = Server._internal();
  factory Server() => _instance;
  Server._internal();

  Alfred? _app;
  String get host => Constants.host;
  int get port => _app?.server?.port ?? 8080;

  FutureOr<void> init({bool printRoutes = true}) async {
    // initialize alfred:
    _app = Alfred(
      // limit the maximum number of concurrent connections:
      simultaneousProcessing: 15000,
      logLevel: LogType.error,
      onNotFound: onNotFoundHandler,
      onInternalError: errorHandler,
    )
      ..all('*', cors())
      ..post(
        'user/register',
        UserRegisterController(),
        middleware: [
          UserRegisterMiddleware(),
        ],
      )
      ..get(
        'user/activate/:activationKey',
        ActivateUserController(),
        middleware: [
          ActivateUserMiddleware(),
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
        'organization/:id',
        UpdateOrganizationController(),
        middleware: [
          AuthenticationMiddleware(),
          UpdateOrganizationMiddleware(),
        ],
      )
      ..post(
        'organization/join/:refId',
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
        'clock/in/:id',
        ClockInController(),
        middleware: [
          AuthenticationMiddleware(),
          ClockInMiddleware(),
        ],
      )
      ..post(
        'clock/out/:id',
        ClockOutController(),
        middleware: [
          AuthenticationMiddleware(),
          ClockOutMiddleware(),
        ],
      )
      ..get(
        'clock/list',
        ClockListController(),
        middleware: [
          AuthenticationMiddleware(),
          ClockListMiddleware(),
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
      ..all(
        '/',
        (req, res) => res.redirect(Uri.parse(Constants.redirectHomepage)),
      )
      ..registerOnDoneListener(errorPluginOnDoneHandler);

    if (printRoutes) _app?.printRoutes();

    // start the alfred server:
    await _app?.listen(port);
    print('Server started on: $host:$port');
  }

  Future<void>? close() async {
    try {
      await _app?.close();
    } catch (_) {}
  }
}

FutureOr<dynamic> errorHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = 500;
  return {'message': 'error not handled'};
}

FutureOr<dynamic> onNotFoundHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = 404;
  return {'message': '${req.requestedUri.path} not found'};
}
