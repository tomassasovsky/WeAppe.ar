part of 'login.dart';

class UserLoginController extends Controller<UserLoginController> {
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    password = req.store.get<String>('password');
    email = req.store.get<String>('email');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final user = await User.generic.findOne(where.eq('email', email));

    if (user == null) {
      throw AlfredException(401, {
        'message': 'Login failed; Invalid user ID or password.',
      });
    }

    final correctPassword = DBCrypt().checkpw(
      password,
      user.password,
    );

    if (!correctPassword) {
      throw AlfredException(401, {
        'message': 'Login failed; Invalid user ID or password',
      });
    }

    final refreshToken = JWT(
      {'userId': user.id?.$oid},
      issuer: 'https://weappe.ar',
    ).sign(
      Constants.jwtRefreshSignature,
      expiresIn: const Duration(days: 90),
    );

    // save the refresh token in the database:
    final refTokenDB = RefreshTokenDB(
      userId: user.id!,
      refreshToken: refreshToken,
    );

    final refTokenResult = await refTokenDB.save();

    if (refTokenResult.isFailure) {
      throw AlfredException(500, {
        'message': 'Error saving refresh token to database',
      });
    }

    final accessToken = JWT(
      {
        'userId': user.id?.$oid,
        'refreshTokenId': (refTokenResult.id as ObjectId?)?.$oid,
      },
      issuer: 'https://weappe.ar',
    ).sign(
      Constants.jwtAccessSignature,
      expiresIn: const Duration(days: 7),
    );

    await res.json({
      'user': user.toJson(showPassword: false, standardEncoding: true),
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    });
  }

  @override
  UserLoginController get newInstance => UserLoginController();
}
