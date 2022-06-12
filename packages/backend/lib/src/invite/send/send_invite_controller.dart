part of 'send_invite.dart';

class InviteCreateController extends Controller<InviteCreateController> {
  late final User user;
  late final Organization organization;
  late final ObjectId organizationId;
  late final String recipientEmail;
  late final String? message;
  late final UserType userType;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    user = req.store.get<User>('user');
    organization = req.store.get<Organization>('organization');
    organizationId = req.store.get<ObjectId>('organizationId');
    recipientEmail = req.store.get<String>('recipientEmail');
    message = req.store.get<String?>('message');
    userType = req.store.get<UserType>('userType');
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final invite = Invite(
      emitter: userId,
      recipient: recipientEmail,
      organization: organizationId,
      refId: const Uuid().v4(),
      userType: userType,
      message: message,
    );

    final wasSent = await EmailSenderService().sendInvite(
      to: recipientEmail,
      organization: organization,
      message: message,
      refId: invite.refId,
    );

    if (!wasSent) {
      throw AlfredException(500, {
        'message':
            'Failed to send invite. Contact the administrator to set up the email configurations.',
      });
    }

    final result = await invite.save();

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

  @override
  InviteCreateController get newInstance => InviteCreateController();
}
