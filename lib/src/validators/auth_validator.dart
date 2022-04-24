part of 'validators.dart';

@reflector
class AuthenticationMiddleware extends Middleware {
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

    if (token.isEmpty) {
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
    } catch (e) {
      throw AlfredException(401, {
        'message': 'invalid token',
      });
    }

    try {
      final rawUserId = (parsedToken.payload as Map<String, dynamic>)['userId'] as String;
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
    } catch (e) {
      throw AlfredException(401, {
        'message': 'unauthorized',
      });
    }
  }
}
