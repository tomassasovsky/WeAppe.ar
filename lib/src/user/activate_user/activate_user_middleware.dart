part of 'activate_user.dart';

class ActivateUserMiddleware extends Middleware<ActivateUserMiddleware> {
  late final String activationKey;

  @override
  FutureOr defineVars(HttpRequest req, HttpResponse res) async {
    activationKey = await InputVariableValidator<String>(req, 'activationKey', source: Source.query).required();
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    req.store.set('activationKey', activationKey);
  }

  @override
  ActivateUserMiddleware get newInstance => ActivateUserMiddleware();
}
