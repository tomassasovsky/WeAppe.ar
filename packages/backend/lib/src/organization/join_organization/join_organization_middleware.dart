part of 'join_organization.dart';

class JoinOrganizationMiddleware
    extends Middleware<JoinOrganizationMiddleware> {
  late final String refId;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    refId = await InputVariableValidator<String>(
      req,
      'refId',
      source: Source.query,
      regExp: Validators.uuidRegExp,
      regExpErrorMessage:
          'refId must be a string of alphanumeric characters. please make sure you have entered the correct refId',
    ).required();

    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final invite = await Invite.generic.byRefId(refId);

    if (invite == null) {
      throw AlfredException(404, {
        'message': 'No invite found',
      });
    }

    if (invite.isExpired) {
      throw AlfredException(403, {
        'message': 'invite is expired',
      });
    }

    final organization = await Organization.generic.byId(invite.organization);

    if (organization == null) {
      throw AlfredException(404, {
        'message': 'No organization found',
      });
    }

    if ((organization.employees ?? []).contains(userId) &&
        invite.userType == UserType.employee) {
      throw AlfredException(400, {
        'message':
            'User is already a member of this organization as an employee',
      });
    }

    if ((organization.employers ?? []).contains(userId) &&
        invite.userType == UserType.employer) {
      throw AlfredException(400, {
        'message':
            'User is already a member of this organization as an employer',
      });
    }

    if (organization.admin == userId) {
      throw AlfredException(400, {
        'message': "User is already this organization's admin",
      });
    }

    req.store.set('invite', invite);
    req.store.set('organization', organization);
  }

  @override
  JoinOrganizationMiddleware get newInstance => JoinOrganizationMiddleware();
}
