part of 'update.dart';

class UserUpdateController extends Controller<UserUpdateController> {
  late final User user;
  String? country;
  String? city;
  HttpBodyFileUpload? photo;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    user = req.store.get<User>('user');
    country = req.store.tryGet<String?>('country');
    city = req.store.tryGet<String?>('city');
    photo = req.store.tryGet<HttpBodyFileUpload>('photo');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    if (city != null && country != null && user.country != country && user.city != city) {
      user
        ..country = country ?? user.country
        ..city = city ?? user.city;

      await user.save();
    }

    if (photo != null) {
      final result = await Services().imgurClient.uploadImage(photo!);
      if (result?.success ?? false) {
        user.photo = result?.data?.link;
        await user.save();
      }
    }

    // and return the user and tokens
    res.statusCode = HttpStatus.ok;
    await res.json(
      user.toJson(showPassword: false, standardEncoding: true),
    );
  }

  @override
  UserUpdateController get newInstance => UserUpdateController();
}
