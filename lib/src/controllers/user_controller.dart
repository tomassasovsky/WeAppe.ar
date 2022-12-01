import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/user_service.dart';

class UserController extends Controller {
  UserController() {
    final service = UserService();
    router
      ..post('/$path/register', service.register)
      ..post('/$path/login', service.login)
      ..get('/$path/activate/<activationKey>', service.activateUser);
  }

  @override
  String get path => '/users';
}
