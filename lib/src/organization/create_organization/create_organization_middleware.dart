part of 'create_organization.dart';

class CreateOrganizationMiddleware extends AuthenticationMiddleware {
  const CreateOrganizationMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final body = await req.bodyAsJsonMap;

    final dynamic name = body['name'];
    final dynamic homePageUrl = body['homePageUrl'];

    if (name == null || (name as String).isEmpty) {
      res.reasonPhrase = 'nameRequired';
      throw AlfredException(400, {
        'message': 'name is required!',
      });
    } else if (name.length > 30) {
      res.reasonPhrase = 'nameTooLong';
      throw AlfredException(400, {
        'message': 'name is too long. max length is 30!',
      });
    }

    req.store.set('name', name);
    req.store.set('homePageUrl', homePageUrl);
  }
}
