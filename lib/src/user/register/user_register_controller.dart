part of 'register.dart';

class UserRegisterController extends Controller<UserRegisterController> {
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
      final result = await user.save();

      if (result.isFailure) {
        throw AlfredException(403, {
          'message': 'Could not create user',
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

      res.statusCode = HttpStatus.ok;
      await res.json({
        'user': user.toJson(showPassword: false),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      });
    } on AlfredException {
      rethrow;
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }

  @override
  UserRegisterController get newInstance => UserRegisterController();
}
