part of 'join_organization.dart';

class JoinOrganizationController {
  const JoinOrganizationController();

  FutureOr<dynamic> call(HttpRequest req, HttpResponse res) async {
    final organization = req.store.get<Organization>('organization');
    final invite = req.store.get<Invite>('invite');
    final user = req.store.get<User>('user');

    final userId = user.id;

    if (userId == null) {
      throw AlfredException(404, {
        'message': 'No user found',
      });
    }

    organization.employers?.add(userId);
    final result = await organization.save();
    if (result == null) {
      throw AlfredException(500, {
        'message': 'Could not join organization',
      });
    }

    await invite.delete();

    await res.json(organization);
  }
}
