part of 'join_organization.dart';

class JoinOrganizationController {
  const JoinOrganizationController();

  FutureOr<dynamic> call(HttpRequest req, HttpResponse res) async {
    final organization = req.store.get<Organization>('organization');
    final user = req.store.get<User>('user');

    final userId = user.id;

    if (userId == null) {
      throw AlfredException(404, {
        'message': 'No user found',
      });
    }

    organization.employers?.add(userId);
    await organization.save();

    await res.json(organization);
  }
}
