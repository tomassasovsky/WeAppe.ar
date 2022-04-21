part of 'register.dart';

class UserRegisterMiddleware {
  const UserRegisterMiddleware();

  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final dynamic email = body['email'];
    final dynamic password = body['password'];
    final dynamic firstName = body['firstName'];
    final dynamic lastName = body['lastName'];

    if (email == null || password == null || firstName == null || lastName == null) {
      res.reasonPhrase = 'fieldsRequired';
      throw AlfredException(400, {
        'message': 'fields are required: email, password, firstName, lastName',
      });
    }

    if (email is! String || password is! String || firstName is! String || lastName is! String) {
      res.reasonPhrase = 'strings required';
      throw AlfredException(400, {
        'message': 'fields must be strings',
      });
    }

    final passwordIsValid = Constants.passwordRegExp.hasMatch(password);
    final emailIsValid = Constants.emailRegExp.hasMatch(email);

    final firstNameIsValid = firstName.isNotEmpty;
    final lastNameIsValid = lastName.isNotEmpty;

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

    if (!firstNameIsValid || !lastNameIsValid) {
      res.reasonPhrase = 'nameError';
      throw AlfredException(400, {
        'message': 'first and last name are required',
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
