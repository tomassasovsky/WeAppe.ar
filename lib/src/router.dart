import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:weappear_backend/src/controllers/organization_controller.dart';
import 'package:weappear_backend/src/controllers/record_controller.dart';
import 'package:weappear_backend/src/controllers/user_controller.dart';
import 'package:weappear_backend/src/utils/middlewares.dart';

/// {@template we_appear_router}
/// The [WeAppearRouter] is a class that is used to group routes together and
/// register them with the proper Controllers.
/// {@endtemplate}
class WeAppearRouter {
  /// {@macro we_appear_router}
  WeAppearRouter() {
    final app = Router()
      ..get('/ping', (Request _) => Response.ok('pong'))
      ..mount('/', UserController().router)
      ..mount('/', OrganizationController().router)
      ..mount(
        '/',
        addMiddleWares(
          RecordsController().router,
          [Middlewares.tokenMiddleware],
        ),
      );

    appPipeline = addMiddleWares(
      app,
      [Middlewares.corsMiddleware],
    );
  }

  /// Local app client
  late final Handler appPipeline;
}
