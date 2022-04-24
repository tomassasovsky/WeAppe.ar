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
