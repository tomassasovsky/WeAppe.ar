part of 'update.dart';

class UserUpdateController {
  const UserUpdateController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    // grab the refresh token from the request
    final country = req.store.tryGet<String?>('country');
    final city = req.store.tryGet<String?>('city');
    final photo = req.store.tryGet<HttpBodyFileUpload>('photo');
    final user = req.store.get<User>('user');

    user
      ..country = country ?? user.country
      ..city = city ?? user.city;

    await user.save();

    if (photo != null) {
      final result = await Services().imgurClient.uploadImage(photo);
      user.photo = result?.data?.link;

      await user.save();
    }

    // and return the user and tokens
    res.statusCode = HttpStatus.ok;
    await res.json(
      user.toJson(showPassword: false),
    );
  }
}
