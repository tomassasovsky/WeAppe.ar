part of 'update_organization.dart';

class UpdateOrganizationMiddleware extends AuthenticationMiddleware {
  const UpdateOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final body = await req.bodyAsJsonMap;

    final dynamic id = req.params['id'] as String?;

    if (id == null || (id as String).isEmpty) {
      res.reasonPhrase = 'nameRequired';
      throw AlfredException(400, {
        'message': "the organization's id is required",
      });
    }

    final dynamic homePageUrl = body['homePageUrl'];
    final dynamic photo = body['photo'] as HttpBodyFileUpload?;

    final userId = req.store.get<User>('user').id;
    if (userId == null) {
      res.reasonPhrase = 'userIdNotFound';
      throw AlfredException(500, {
        'message': 'userId is null',
      });
    }

    final organization = await services.organizations.findOrganizationById(id);

    if (organization == null) {
      res.reasonPhrase = 'organizationDoesNotExist';
      throw AlfredException(404, {
        'message': 'you have no organizations with this id!',
      });
    }

    if (organization.admin != userId.$oid) {
      res.reasonPhrase = 'userIsNotOrganizationAdmin';
      throw AlfredException(403, {
        'message':
            'you are not the admin of this organization\n\nWe trust you have received the usual lecture from the local System Administrator. It usually boils down to these three things:\n#1) Respect the privacy of others.\n#2) Think before you type.\n#3) With great power comes great responsibility.',
      });
    }

    if ((photo == null || photo == organization.imageUrl) && (homePageUrl == null || homePageUrl == organization.homePageUrl)) {
      res.reasonPhrase = 'nothingToUpdate';
      throw AlfredException(202, {
        'message': 'nothing to update!',
      });
    }

    req.store.set('homePageUrl', homePageUrl);
    req.store.set('organization', organization);
    req.store.set('photo', photo);
  }
}
