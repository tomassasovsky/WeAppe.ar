part of 'update_organization.dart';

@reflector
class UpdateOrganizationController extends Controller {
  late final Organization organization;
  String? homePageUrl;
  HttpBodyFileUpload? photo;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    organization = req.store.get<Organization>('organization');
    homePageUrl = req.store.tryGet<String>('homePageUrl');
    photo = req.store.tryGet<HttpBodyFileUpload?>('photo');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    organization.homePageUrl = homePageUrl ?? organization.homePageUrl;

    if (photo != null) {
      final result = await Services().imgurClient.uploadImage(photo!);
      organization.imageUrl = result?.data?.link;
    }

    final result = await organization.save();
    if (result?['ok'] == 0) {
      res.reasonPhrase = 'organizationNotUpdated';
      throw AlfredException(500, {
        'message': 'something went wrong while updating the organization. sorry!',
      });
    }

    res.statusCode = 200;
    await res.json(organization.toJson());
  }
}
