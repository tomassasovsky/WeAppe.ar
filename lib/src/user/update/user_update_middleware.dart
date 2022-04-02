part of 'update.dart';

class UserUpdateMiddleware extends AuthenticationMiddleware {
  const UserUpdateMiddleware();

  @override
  Future<dynamic> call(HttpRequest req, HttpResponse res) async {
    await super.call(req, res);
    final body = await req.bodyAsJsonMap;

    final dynamic country = body['country'];
    final dynamic city = body['city'];
    final dynamic photo = body['photo'] as HttpBodyFileUpload?;

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
