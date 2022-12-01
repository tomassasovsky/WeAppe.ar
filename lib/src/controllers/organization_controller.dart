import 'package:shelf/shelf.dart';
import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/organization_service.dart';
import 'package:weappear_backend/src/utils/middlewares.dart';

class OrganizationController extends Controller {
  OrganizationController() {
    final service = OrganizationService();
    router.mount(
        path,
        Pipeline().addHandler(
          router
            ..post(
                '/',
                Pipeline()
                    .addMiddleware(Middlewares.tokenMiddleware)
                    .addHandler(service.create))
            ..post(
                '/invite',
                Pipeline()
                    .addMiddleware(Middlewares.tokenMiddleware)
                    .addHandler(service.sendInviteByMail))
            ..get('/join/<refId>/<userId>', service.joinOrganization),
        ));

    ;
  }

  @override
  String get path => '/organizations';
}
