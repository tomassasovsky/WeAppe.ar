import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/organization_service.dart';

class OrganizationController extends Controller {
  OrganizationController() {
    final service = OrganizationService();
    router
      ..post(path, service.create)
      ..post('$path/invite', service.sendInviteByMail)
      ..get('$path/join/<refId>/<userId>', service.joinOrganization);
  }

  @override
  String get path => '/organizations';
}
