import 'package:shelf/shelf.dart';
import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/user_service.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template user_controller}
/// This controller has all the routes for the users collection.
/// {@endtemplate}
class UserController extends Controller {
  /// {@macro user_controller}
  UserController() {
    final service = UserService();
    router.mount(
      path,
      const Pipeline().addHandler(
        router
          ..post('/register', service.register)
          ..post('/login', service.login)
          ..post('/verify-email', service.verifyEmail)
          ..post('/activate', service.activateUser)
          ..put(
            '/update-info',
            addMiddleWares(
              service.updateInfo,
              [Middlewares.tokenMiddleware],
            ),
          )
          ..put(
            '/update-password',
            addMiddleWares(
              service.updatePassword,
              [Middlewares.tokenMiddleware],
            ),
          ),
      ),
    );
  }

  @override
  String get path => '/users';
}
