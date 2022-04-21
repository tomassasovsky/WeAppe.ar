part of 'validators.dart';

class AuthenticationMiddleware {
  const AuthenticationMiddleware();

  @mustCallSuper
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final authHeader = req.headers.value('Authorization');

    if (authHeader == null) {
      throw AlfredException(401, {
        'message': 'no auth header provided',
      });
    }

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
      final userId = (parsedToken.payload as Map<String, dynamic>)['userId'] as String;
      final user = await Services().users.findUserById(userId);

      if (user == null) {
        throw AlfredException(401, {
          'message': 'user not found',
        });
      }

      req.store.set('token', parsedToken);
      req.store.set('user', user);
    } catch (e) {
      throw AlfredException(401, {
        'message': 'unauthorized',
      });
    }
  }
}
