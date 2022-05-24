import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';

final routes = [
  HttpRoute(
    'user/register',
    UserRegisterController(),
    Method.post,
    middleware: [UserRegisterMiddleware()],
  ),
  HttpRoute(
    'user/activate/:activationKey',
    ActivateUserController(),
    Method.get,
    middleware: [ActivateUserMiddleware()],
  ),
  HttpRoute(
    'user/login',
    UserLoginController(),
    Method.post,
    middleware: [UserLoginMiddleware()],
  ),
  HttpRoute(
    'user/logout',
    UserLogoutController(),
    Method.delete,
    middleware: [AuthenticationMiddleware()],
  ),
  HttpRoute(
    'refresh-token',
    RegenerateAccessTokenController(),
    Method.get,
    middleware: [RegenerateAccessTokenMiddleware()],
  ),
  HttpRoute(
    'user',
    UserCurrentController(),
    Method.get,
    middleware: [AuthenticationMiddleware()],
  ),
  HttpRoute(
    'user/update',
    UserUpdateController(),
    Method.put,
    middleware: [
      AuthenticationMiddleware(),
      UserUpdateMiddleware(),
    ],
  ),
  HttpRoute(
    'organization',
    CreateOrganizationController(),
    Method.post,
    middleware: [
      AuthenticationMiddleware(),
      CreateOrganizationMiddleware(),
    ],
  ),
  HttpRoute(
    'organization/:id',
    UpdateOrganizationController(),
    Method.put,
    middleware: [
      AuthenticationMiddleware(),
      UpdateOrganizationMiddleware(),
    ],
  ),
  HttpRoute(
    'organization/join/:refId',
    JoinOrganizationController(),
    Method.post,
    middleware: [
      AuthenticationMiddleware(),
      JoinOrganizationMiddleware(),
    ],
  ),
  HttpRoute(
    'clock/in/:id',
    ClockInController(),
    Method.post,
    middleware: [
      AuthenticationMiddleware(),
      ClockInMiddleware(),
    ],
  ),
  HttpRoute(
    'clock/out/:id',
    ClockOutController(),
    Method.post,
    middleware: [
      AuthenticationMiddleware(),
      ClockOutMiddleware(),
    ],
  ),
  HttpRoute(
    'clock/list',
    ClockListController(),
    Method.get,
    middleware: [
      AuthenticationMiddleware(),
      ClockListMiddleware(),
    ],
  ),
  HttpRoute(
    'invite/send',
    InviteCreateController(),
    Method.post,
    middleware: [
      AuthenticationMiddleware(),
      InviteCreateMiddleware(),
    ],
  ),
];
