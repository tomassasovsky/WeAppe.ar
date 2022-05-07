part of 'create_organization.dart';

@reflector
class CreateOrganizationController extends Controller {
  late final String name;
  late final ObjectId userId;
  late final User user;
  String? homePageUrl;
  HttpBodyFileUpload? photo;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    name = req.store.get<String>('name');
    user = req.store.get<User>('user');
    userId = req.store.get<ObjectId>('userId');
    homePageUrl = req.store.tryGet<String>('homePageUrl');
    photo = req.store.tryGet<HttpBodyFileUpload?>('photo');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final organization = Organization(
      name: name,
      admin: userId,
      homePageUrl: homePageUrl,
    );

    try {
      final saveOrganizationResult = await organization.save();

      if (saveOrganizationResult.isFailure) {
        throw AlfredException(403, {
          'message': 'Failed to create organization',
        });
      }

      user.organizations ??= [];
      user.organizations?.add(organization.id as ObjectId);

      final saveUserResult = await user.save();

      if (saveUserResult.isFailure) {
        throw AlfredException(500, {
          'message': 'Failed to add the organization to the user',
        });
      }

      res.statusCode = 200;
      await res.json(
        organization.toJson(),
      );
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
