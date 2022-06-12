part of 'clock_in.dart';

class ClockInMiddleware extends Middleware<ClockInMiddleware> {
  late final String organizationId;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    organizationId = await InputVariableValidator<String>(
      req,
      'id',
      source: Source.query,
      regExp: Validators.mongoIdRegExp,
      regExpErrorMessage: 'invalid organization id',
    ).required();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final organization = await Organization.generic.byId(organizationId);

    if (organization == null) {
      res.reasonPhrase = 'organizationNotFound';
      throw AlfredException(404, {
        'message': 'organization not found!',
      });
    }

    if (!organization.containsUser(userId)) {
      res.reasonPhrase = 'userNotInOrganization';
      throw AlfredException(404, {
        'message': 'user not in organization!',
      });
    }

    req.store.set('organizationId', organization.id);
  }

  @override
  ClockInMiddleware get newInstance => ClockInMiddleware();
}
