part of 'send_invite.dart';

class InviteCreateMiddleware extends Middleware<InviteCreateMiddleware> {
  InviteCreateMiddleware();

  late final String organizationName;
  late final String recipientEmail;
  late final ObjectId userId;
  String? message;
  String? rawUserType;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    organizationName = await InputVariableValidator<String>(req, 'organizationName').required();
    recipientEmail = await InputVariableValidator<String>(req, 'recipientEmail', regExp: Validators.emailRegExp).required();
    message = await InputVariableValidator<String>(req, 'message').optional();
    rawUserType = await InputVariableValidator<String>(req, 'userType').optional();
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final userType = UserType.values.firstWhere(
      (e) => e.name == rawUserType,
      orElse: () => UserType.employee,
    );

    final organization = await Services().organizations.findOrganizationByNameAndUserId(
          userId: userId.$oid,
          name: organizationName,
        );

    final organizationId = organization?.id;

    if (organization == null || organizationId == null) {
      throw AlfredException(404, {
        'message': 'organization not found',
      });
    }

    final userWithEmail = await Services().users.findUserByEmail(email: recipientEmail);
    if (userWithEmail != null) {
      if ((organization.employees ?? []).contains(userWithEmail.id) && userType == UserType.employee) {
        throw AlfredException(400, {
          'message': 'User is already a member of this organization as an employee',
        });
      }

      if ((organization.employers ?? []).contains(userWithEmail.id) && userType == UserType.employer) {
        throw AlfredException(400, {
          'message': 'User is already a member of this organization as an employer',
        });
      }

      if (organization.admin == userId) {
        throw AlfredException(400, {
          'message': "User is already this organization's admin",
        });
      }
    }

    req.store.set('organization', organization);
    req.store.set('organizationId', organizationId);
    req.store.set('recipientEmail', recipientEmail);
    req.store.set('message', message);
    req.store.set('userType', userType);
  }

  @override
  InviteCreateMiddleware get newInstance => InviteCreateMiddleware();
}
