part of 'login.dart';

class UserLoginMiddleware extends Middleware {
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    email = await InputVariableValidator<String>(req, 'email').required();
    password = await InputVariableValidator<String>(req, 'password').required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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
