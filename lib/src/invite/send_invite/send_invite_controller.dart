part of 'send_invite.dart';

class InviteCreateController {
  const InviteCreateController();

  FutureOr<dynamic> call(HttpRequest req, HttpResponse res) async {
    final user = req.store.get<User>('user');
    final organization = req.store.get<Organization>('organization');
    final recipientEmail = req.store.get<String>('recipientEmail');
    final message = req.store.get<String?>('message');
    final userType = req.store.get<UserType>('userType');

    final userId = user.id;

    if (userId == null) {
      throw AlfredException(500, {
        'message': 'userId not available',
      });
    }

    final organizationId = organization.id;

    if (organizationId == null) {
      throw AlfredException(500, {
        'message': 'organizationId not available',
      });
    }

    final invite = Invite(
      emitter: userId,
      recipient: recipientEmail,
      organization: organizationId,
      refId: const Uuid().v4(),
      userType: userType,
      message: message,
    );

    final wasSent = await services.emailSender.sendInvite(
      to: recipientEmail,
      organization: organization,
      message: message,
      refId: invite.refId,
    );

    if (!wasSent) {
      throw AlfredException(500, {
        'message': 'Failed to send invite. Contact the administrator to set up the email configurations.',
      });
    }

    final result = await services.invites.addToDatabase(
      invite,
    );

    if (result.isFailure) {
      throw AlfredException(500, {
        'message': 'failed to add invite to database',
      });
    }

    invite.id = result.document?['_id'] as ObjectId?;

    res.statusCode = 200;
    final jsonInvite = invite.toJson(showTimestamp: false);
    await res.json(jsonInvite);
  }
}
