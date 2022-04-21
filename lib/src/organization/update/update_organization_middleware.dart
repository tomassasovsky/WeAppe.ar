part of 'update_organization.dart';

class UpdateOrganizationMiddleware extends Middleware {
  late final String id;
  String? homePageUrl;
  HttpBodyFileUpload? photo;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    id = await InputVariableValidator<String>(req, 'id', source: Source.query).required();
    photo = await InputVariableValidator<HttpBodyFileUpload>(req, 'photo').optional().catchError((dynamic _) {});
    homePageUrl = await InputVariableValidator<String>(req, 'homePageUrl').optional().catchError((dynamic _) {});
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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

    if ((photo == null) && (homePageUrl == null || homePageUrl == organization.homePageUrl) && photo == null) {
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
