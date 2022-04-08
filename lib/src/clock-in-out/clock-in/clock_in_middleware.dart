part of 'clock_in.dart';

class ClockInMiddleware extends AuthenticationMiddleware {
  const ClockInMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final body = await req.bodyAsJsonMap;
    final dynamic organizationId = body['organizationId'];

    if (organizationId == null) {
      res.reasonPhrase = 'organizationIdRequired';
      throw AlfredException(400, {
        'message': 'organizationId is required!',
      });
    }

    final organization = await services.organizations
        .findOrganizationById(id: organizationId as String);

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    req.store.set('organizationId', organization.id);
  }
}
