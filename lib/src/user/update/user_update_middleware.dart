part of 'update.dart';

@reflector
class UserUpdateMiddleware extends Middleware {
  String? country;
  String? city;
  HttpBodyFileUpload? photo;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    country = await InputVariableValidator<String>(req, 'country').optional();
    city = await InputVariableValidator<String>(req, 'city').optional();
    photo = await InputVariableValidator<HttpBodyFileUpload>(req, 'photo').optional();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
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
