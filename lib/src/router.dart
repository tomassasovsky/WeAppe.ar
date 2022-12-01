import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:weappear_backend/src/controllers/record_controller.dart';
import 'package:weappear_backend/src/controllers/organization_controller.dart';
import 'package:weappear_backend/src/controllers/user_controller.dart';
import 'package:weappear_backend/src/utils/middlewares.dart';

/// {@template we_appear_router}
/// The [WeAppearRouter] is a class that is used to group routes together and
/// register them with the proper [Controller]s.
/// {@endtemplate}
class WeAppearRouter {
  /// {@macro we_appear_router}
  WeAppearRouter() {
    final app = Router()..get('/ping', (Request _) => Response.ok('pong'));
    app
      ..mount('/', UserController().router)
      ..mount('/', OrganizationController().router)
      ..mount(
          '/',
          const Pipeline()
              .addMiddleware(Middlewares.tokenMiddleware)
              .addHandler(RecordsController().router));

    appPipeline = const Pipeline()
        .addMiddleware(Middlewares.corsMiddleware)
        .addHandler(app);
  }

  /// Local app client
  late final Handler appPipeline;
}
