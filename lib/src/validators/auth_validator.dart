part of 'validators.dart';

class AuthenticationMiddleware extends Middleware<AuthenticationMiddleware> {
  late final String authHeader;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    authHeader = await InputVariableValidator<String>(
      req,
      'Authorization',
      source: Source.headers,
    ).required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final token = authHeader.replaceAll('Bearer ', '');

    if (token.isEmpty || token.toLowerCase() == 'null') {
      throw AlfredException(401, {
        'message': 'no token provided',
      });
    }

    late final JWT parsedToken;
    try {
      parsedToken = JWT.verify(
        token,
        Services().jwtAccessSigner,
      );
    } on JWTError {
      throw AlfredException(401, {
        'message': 'invalid token',
      });
    }

    final rawUserId = (parsedToken.payload as Map<String, dynamic>)['userId'] as String;
    final rawRefreshTokenId = (parsedToken.payload as Map<String, dynamic>)['refreshTokenId'] as String?;

    final refreshTokenDb = await Services().tokens.findById(rawRefreshTokenId);

    if (refreshTokenDb == null || !refreshTokenDb.isValid) {
      throw AlfredException(401, {
        'message': 'no refresh token linked to this access token. please login again',
      });
    }

    final user = await Services().users.findUserById(rawUserId);
    final userId = user?.id;

    if (user == null || userId == null) {
      throw AlfredException(401, {
        'message': 'user not found',
      });
    }

    req.store.set('token', parsedToken);
    req.store.set('user', user);
    req.store.set('userId', userId);
  }

  @override
  AuthenticationMiddleware get newInstance => AuthenticationMiddleware();
}
