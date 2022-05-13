part of 'clock_list.dart';

class ClockListMiddleware extends Middleware<ClockListMiddleware> {
  late final ObjectId userId;
  String? organizationId;
  int? qty;
  int? from;
  int? to;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    organizationId = await InputVariableValidator<String>(
      req,
      'organizationId',
      source: Source.body,
      regExp: Validators.mongoIdRegExp,
      regExpErrorMessage: 'invalid organization id',
    ).optional();
    qty = await InputVariableValidator<int>(req, 'qty', source: Source.body)
        .optional();
    from = await InputVariableValidator<int>(req, 'from', source: Source.body)
        .optional();
    to = await InputVariableValidator<int>(req, 'to', source: Source.body)
        .optional();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    if (organizationId != null) {
      final organization = await Services().organizations.findOrganizationById(
            organizationId,
          );
      if (organization == null || (organizationId?.isEmpty ?? true)) {
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
    }

    req.store.set('organizationId', organizationId);
    req.store.set('qty', qty ?? 100);
    req.store.set('from', Timestamp(from ?? 0));
    req.store.set('to', Timestamp(to));
  }

  @override
  ClockListMiddleware get newInstance => ClockListMiddleware();
}
