part of 'update.dart';

class UserUpdateMiddleware extends AuthenticationMiddleware {
  const UserUpdateMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);

    final country = await InputVariableValidator<String>(req, 'country').optional();
    final city = await InputVariableValidator<String>(req, 'city').optional();
    final photo = await InputVariableValidator<HttpBodyFileUpload>(req, 'photo').optional();

    req.validate();

    if (country == null && city == null && photo == null) {
      res.reasonPhrase = 'nothingToUpdate';
      throw AlfredException(202, {
        'message': 'nothing to update!',
      });
    }

    if (country != null) req.store.set('country', country);
    if (city != null) req.store.set('city', city);
    if (photo != null) req.store.set('photo', photo);
  }
}
