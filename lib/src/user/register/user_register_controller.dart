part of 'register.dart';

class UserRegisterController {
  const UserRegisterController();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    // grab the properties from the request
    final firstName = req.store.get<String>('firstName');
    final lastName = req.store.get<String>('lastName');
    final email = req.store.get<String>('email');
    final password = req.store.get<String>('password');

    final hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());

    final user = User(
      email: email,
      firstName: firstName,
      lastName: lastName,
      password: hashedPassword,
    );

    try {
      await user.save();

      final jwt = JWT(
        {'userId': user.id?.$oid},
        issuer: 'https://weappe.ar',
      );

      final accessToken = jwt.sign(
        Services().jwtAccessSigner,
        expiresIn: const Duration(days: 7),
      );

      final refreshToken = jwt.sign(
        Services().jwtRefreshSigner,
        expiresIn: const Duration(days: 90),
      );

      await Services().tokens.addToDatabase(user.id, refreshToken);

      res.statusCode = HttpStatus.ok;
      await res.json({
        'user': user.toJson(showPassword: false),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      });
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
