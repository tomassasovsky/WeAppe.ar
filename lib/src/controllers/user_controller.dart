import 'package:shelf/shelf.dart';
import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/user_service.dart';

class UserController extends Controller {
  UserController() {
    final service = UserService();
    router.mount(
      path,
      Pipeline().addHandler(
        router
          ..post('/register', service.register)
          ..post('/login', service.login)
          ..get('/activate/<activationKey>', service.activateUser)
          ..put('/update-info', service.updateInfo)
          ..put('/update-password', service.updatePassword),
      ),
    );
  }

  @override
  String get path => '/users';
}
