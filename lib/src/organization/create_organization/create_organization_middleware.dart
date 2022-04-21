part of 'create_organization.dart';

class CreateOrganizationMiddleware extends AuthenticationMiddleware {
  const CreateOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final name = await InputVariableValidator<String>(req, 'name').required();
    final homePageUrl = await InputVariableValidator<String>(req, 'homePageUrl').optional();

    req.validate();

    final userId = req.store.get<User>('user').id;
    if (userId == null) {
      res.reasonPhrase = 'userIdNotFound';
      throw AlfredException(500, {
        'message': 'userId is null',
      });
    }

    final organizationExists = await Services().organizations.findOrganizationByNameAndUserId(name: name, userId: userId.$oid) != null;

    if (organizationExists) {
      res.reasonPhrase = 'organizationAlreadyExists';
      throw AlfredException(409, {
        'message': 'you already created an organization with that name!',
      });
    }

    req.store.set('name', name);
    req.store.set('homePageUrl', homePageUrl);
  }
}
