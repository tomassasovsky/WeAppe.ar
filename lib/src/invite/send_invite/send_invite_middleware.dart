part of 'send_invite.dart';

class InviteCreateMiddleware extends AuthenticationMiddleware {
  const InviteCreateMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final user = req.store.get<User>('user');

    final organizationName = await InputVariableValidator<String>(req, 'organizationName').required();
    final recipientEmail = await InputVariableValidator<String>(req, 'recipientEmail').required();
    final message = await InputVariableValidator<String>(req, 'message').optional();
    final rawUserType = await InputVariableValidator<String>(req, 'userType').optional();

    req.validate();

    final userId = user.id;

    final isValidEmail = Constants.emailRegExp.hasMatch(recipientEmail);
    if (!isValidEmail) {
      throw AlfredException(400, {
        'message': 'recipientEmail is invalid',
      });
    }

    if (userId == null) {
      throw AlfredException(500, {
        'message': 'userId not available',
      });
    }

    final userType = UserType.values.firstWhere(
      (e) => e.name == rawUserType,
      orElse: () => UserType.employee,
    );

    final organization = await Services().organizations.findOrganizationByNameAndUserId(
          userId: userId.$oid,
          name: organizationName,
        );

    if (organization == null) {
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
    req.store.set('recipientEmail', recipientEmail);
    req.store.set('message', message);
    req.store.set('userType', userType);
  }
}
