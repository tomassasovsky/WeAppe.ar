part of 'update_organization.dart';

class UpdateOrganizationMiddleware extends AuthenticationMiddleware {
  const UpdateOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final id = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    final homePageUrl = await InputVariableValidator<String>(req, 'homePageUrl').optional();
    final photo = await InputVariableValidator<HttpBodyFileUpload>(req, 'photo').optional();

    req.validate();

    final userId = req.store.get<User>('user').id;
    if (userId == null) {
      res.reasonPhrase = 'userIdNotFound';
      throw AlfredException(500, {
        'message': 'userId is null',
      });
    }

    final organization = await Services().organizations.findOrganizationById(id);

    if (organization == null) {
      res.reasonPhrase = 'organizationDoesNotExist';
      throw AlfredException(404, {
        'message': 'you have no organizations with this id!',
      });
    }

    if (organization.admin != userId) {
      res.reasonPhrase = 'userIsNotOrganizationAdmin';
      throw AlfredException(403, {
        'message':
            'you are not the admin of this organization\n\nWe trust you have received the usual lecture from the local System Administrator. It usually boils down to these three things:\n#1) Respect the privacy of others.\n#2) Think before you type.\n#3) With great power comes great responsibility.',
      });
    }

    if ((photo == null) && (homePageUrl == null || homePageUrl == organization.homePageUrl)) {
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
