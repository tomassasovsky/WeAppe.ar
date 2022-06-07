part of 'regenerate_access_token.dart';

class RegenerateAccessTokenMiddleware extends Middleware<RegenerateAccessTokenMiddleware> {
  late final String authHeader;

  @override
  FutureOr defineVars(HttpRequest req, HttpResponse res) async {
    authHeader = await InputVariableValidator<String>(
      req,
      'Authorization',
      source: Source.headers,
    ).required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final token = authHeader.replaceAll('Bearer ', '');

    print(token);

    if (token.isEmpty || token.toLowerCase() == 'null') {
      throw AlfredException(401, {
        'message': 'no token provided',
      });
    }

    try {
      JWT.verify(
        token,
        Services().jwtRefreshSigner,
      );
    } on JWTError {
      throw AlfredException(401, {
        'message': 'invalid token',
      });
    } on FormatException {
      throw AlfredException(401, {
        'message': 'invalid token',
      });
    }

    final refreshTokenDb = await Services().tokens.findByTokenValue(token);

    if (refreshTokenDb == null || !refreshTokenDb.isValid) {
      throw AlfredException(401, {
        'message': 'no refresh token linked to this access token. please login again',
      });
    }

    final user = await Services().users.findUserById(refreshTokenDb.userId);

    if (user == null) {
      throw AlfredException(401, {
        'message': 'user not found',
      });
    }

    req.store.set('token', refreshTokenDb);
  }

  @override
  RegenerateAccessTokenMiddleware get newInstance => RegenerateAccessTokenMiddleware();
}
