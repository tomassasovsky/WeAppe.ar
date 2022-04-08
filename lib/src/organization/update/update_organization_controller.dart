part of 'update_organization.dart';

class UpdateOrganizationController {
  const UpdateOrganizationController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final organization = req.store.get<Organization>('organization');
    final homePageUrl = req.store.tryGet<String>('homePageUrl');
    final photo = req.store.tryGet<HttpBodyFileUpload?>('photo');

    try {
      organization.homePageUrl = homePageUrl ?? organization.homePageUrl;

      if (photo != null) {
        final result = await services.imgurClient.uploadImage(photo);
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
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
