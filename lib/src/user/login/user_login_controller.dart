part of 'login.dart';

class UserLoginController extends Controller {
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    password = req.store.get<String>('password');
    email = req.store.get<String>('email');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final user = await Services().users.findUserByEmail(
          email: email,
        );

    if (user == null || user.password.isEmpty) {
      throw AlfredException(401, {
        'message': 'combination of email and password is invalid',
      });
    }

    try {
      final isCorrect = DBCrypt().checkpw(
        password,
        user.password,
      );

      if (isCorrect == false) {
        throw AlfredException(401, {
          'message': 'Invalid password',
        });
      }

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

      // save the refresh token in the database:
      await Services().tokens.addToDatabase(user.id, refreshToken);

      return {
        'user': user.toJson(showPassword: false),
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      };
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
