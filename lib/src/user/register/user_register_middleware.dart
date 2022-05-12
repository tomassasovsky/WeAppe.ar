part of 'register.dart';

class UserRegisterMiddleware extends Middleware<UserRegisterMiddleware> {
  late final String email;
  late final String password;
  late final String firstName;
  late final String lastName;

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

    firstName = await InputVariableValidator<String>(req, 'firstName').required();
    lastName = await InputVariableValidator<String>(req, 'lastName').required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    req.store.set('email', email);
    req.store.set('password', password);
    req.store.set('firstName', firstName);
    req.store.set('lastName', lastName);
  }

  @override
  UserRegisterMiddleware get newInstance => UserRegisterMiddleware();
}
