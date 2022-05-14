part of 'login.dart';

class UserLoginMiddleware extends Middleware<UserLoginMiddleware> {
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    email = await InputVariableValidator<String>(
      req,
      'email',
      regExp: Validators.emailRegExp,
      regExpErrorMessage: 'email must be a valid email address',
    ).required();
    password = await InputVariableValidator<String>(
      req,
      'password',
      regExp: Validators.passwordRegExp,
      regExpErrorMessage: 'password must be at least 8 characters long, contain at least one lowercase letter, one uppercase letter, one number, and one special character',
    ).required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    req.store.set('email', email);
    req.store.set('password', password);
  }

  @override
  UserLoginMiddleware get newInstance => UserLoginMiddleware();
}
