import 'package:shelf/shelf.dart';
import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/organization_service.dart';
import 'package:weappear_backend/src/utils/middlewares.dart';

/// {@template organization_controller}
/// This controller has all the routes for the organizations collection.
/// {@endtemplate}
class OrganizationController extends Controller {
  /// {@macro organization_controller}
  OrganizationController() {
    final service = OrganizationService();
    router.mount(
      path,
      const Pipeline().addHandler(
        router
          ..post(
            '/',
            addMiddleWares(
              service.create,
              [Middlewares.tokenMiddleware],
            ),
          )
          ..post(
            '/invite',
            addMiddleWares(
              service.sendInviteByMail,
              [Middlewares.tokenMiddleware],
            ),
          )
          ..get('/join/<refId>/<userId>', service.joinOrganization),
      ),
    );
  }

  @override
  String get path => '/organizations';
}
