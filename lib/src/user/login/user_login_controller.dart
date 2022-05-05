part of 'login.dart';

@reflector
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
        'message': 'Login failed; Invalid user ID or password.',
      });
    }

    try {
      final isCorrect = DBCrypt().checkpw(
        password,
        user.password,
      );

      if (isCorrect == false) {
        throw AlfredException(401, {
          'message': 'Login failed; Invalid user ID or password',
        });
      }

      final refreshToken = JWT(
        {'userId': user.id?.$oid},
        issuer: 'https://weappe.ar',
      ).sign(
        Services().jwtRefreshSigner,
        expiresIn: const Duration(days: 90),
      );

      // save the refresh token in the database:
      final refTokenResult = await Services().tokens.addToDatabase(user.id, refreshToken);

      final accessToken = JWT(
        {
          'userId': user.id?.$oid,
          'refreshTokenId': (refTokenResult.id as ObjectId?)?.$oid,
        },
        issuer: 'https://weappe.ar',
      ).sign(
        Services().jwtAccessSigner,
        expiresIn: const Duration(days: 7),
      );

      await res.json({
        'user': user.toJson(showPassword: false),
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      });
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }
}
