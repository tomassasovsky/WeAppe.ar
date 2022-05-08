part of 'join_organization.dart';

@reflector
class JoinOrganizationController extends Controller {
  late final Organization organization;
  late final Invite invite;
  late final User user;
  late final ObjectId userId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    organization = req.store.get<Organization>('organization');
    invite = req.store.get<Invite>('invite');
    user = req.store.get<User>('user');
    userId = req.store.get<ObjectId>('userId');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    organization.employers ??= [];
    organization.employers?.add(userId);
    final result = await organization.save();
    if (result.isFailure) {
      throw AlfredException(500, {
        'message': 'Could not join organization',
      });
    }

    await invite.delete();

    await res.json(organization);
  }
}
