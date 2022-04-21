part of 'register.dart';

class UserRegisterController extends Controller {
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    firstName = req.store.get<String>('firstName');
    lastName = req.store.get<String>('lastName');
    email = req.store.get<String>('email');
    password = req.store.get<String>('password');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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
