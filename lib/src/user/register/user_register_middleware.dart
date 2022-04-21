part of 'register.dart';

class UserRegisterMiddleware {
  const UserRegisterMiddleware();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final email = await InputVariableValidator<String>(req, 'email').required();
    final password = await InputVariableValidator<String>(req, 'password').required();
    final firstName = await InputVariableValidator<String>(req, 'firstName').required();
    final lastName = await InputVariableValidator<String>(req, 'lastName').required();

    req.validate();

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

    final savedUser = await Services().users.findUserByEmail(email: email);
    final found = savedUser != null;
    if (found) {
      res.reasonPhrase = 'userExists';
      throw AlfredException(400, {
        'message': 'user with email already exists',
      });
    }

    req.store.set('email', email);
    req.store.set('password', password);
    req.store.set('firstName', firstName);
    req.store.set('lastName', lastName);
  }
}
