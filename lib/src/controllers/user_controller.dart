import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/user_service.dart';

class UserController extends Controller {
  UserController() {
    final service = UserService();
    router
      ..post('/user/register', service.register)
      ..post('/user/login', service.login)
      ..get('/user/activate/<activationKey>', service.activateUser);
  }

  @override
  String get path => '/users';
}
