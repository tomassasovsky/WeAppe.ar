part of 'create_organization.dart';

class CreateOrganizationController {
  const CreateOrganizationController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final name = req.store.get<String>('name');
    final homePageUrl = req.store.tryGet<String>('homePageUrl');
    final user = req.store.get<User>('user');

    final organization = Organization(
      name: name,
      admin: user.id!,
      homePageUrl: homePageUrl,
    );

    try {
      final result = await Services().organizations.addToDatabase(
            organization,
          );

      user.organizations ??= [];
      user.organizations?.add(result.id as ObjectId);

      await user.save();

      res.statusCode = 200;
      await res.json(
        <String, dynamic>{
          'id': result.id,
          ...organization.toJson(),
        },
      );
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
