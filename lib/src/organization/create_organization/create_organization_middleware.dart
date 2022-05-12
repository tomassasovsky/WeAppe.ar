part of 'create_organization.dart';

class CreateOrganizationMiddleware extends Middleware<CreateOrganizationMiddleware> {
  late final String name;
  late final ObjectId userId;
  String? homePageUrl;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    name = await InputVariableValidator<String>(req, 'name').required();
    homePageUrl = await InputVariableValidator<String>(req, 'homePageUrl', regExp: Validators.urlRegExp).optional();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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

  @override
  CreateOrganizationMiddleware get newInstance => CreateOrganizationMiddleware();
}
