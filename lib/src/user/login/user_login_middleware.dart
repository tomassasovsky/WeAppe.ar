part of 'login.dart';

class UserLoginMiddleware {
  const UserLoginMiddleware();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final dynamic email = body['email'];
    final dynamic password = body['password'];

    if (email == null || password == null) {
      res.reasonPhrase = 'fieldsRequired';
      throw AlfredException(400, {
        'message': 'fields are required: email, password',
      });
    }

    if (email is! String || password is! String) {
      res.reasonPhrase = 'strings required';
      throw AlfredException(400, {
        'message': 'fields must be strings',
      });
    }

    final passwordIsValid = Constants.passwordRegExp.hasMatch(password);
    final emailIsValid = Constants.emailRegExp.hasMatch(email);

    if (!passwordIsValid) {
      res.reasonPhrase = 'passwordError';
      throw AlfredException(400, {
        'message': 'password must be at least 8 characters long, contain at least one lowercase letter, one uppercase letter, one number, and one special character',
      });
    }

    if (!emailIsValid) {
      res.reasonPhrase = 'emailError';
      throw AlfredException(400, {
        'message': 'email must be a valid email address',
      });
    }

    final found = await Services().users.findUserByEmail(email: email) != null;
    if (!found) {
      res.reasonPhrase = 'invalidCredentials';
      throw AlfredException(400, {
        'message': 'credentials are invalid',
      });
    }

    req.store.set('email', email);
    req.store.set('password', password);
  }
}
