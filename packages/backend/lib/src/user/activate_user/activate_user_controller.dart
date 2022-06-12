part of 'activate_user.dart';

class ActivateUserController extends Controller<ActivateUserController> {
  late final String activationKey;

  @override
  FutureOr defineVars(HttpRequest req, HttpResponse res) {
    activationKey = req.store.get<String>('activationKey');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final userActivation = await UserActivation.generic.findOne(
      where.eq('activationKey', activationKey),
    );

    if (userActivation == null) {
      throw AlfredException(404, {
        'message': 'User activation not found',
      });
    }

    final user = await User.generic.byId(userActivation.userId);
    if (user == null) {
      throw AlfredException(404, {
        'message': 'User not found',
      });
    }

    final result = await user.activate();
    if (result.isFailure) {
      throw AlfredException(500, {
        'message': 'Could not activate user',
      });
    }

    await userActivation.delete();

    res.statusCode = HttpStatus.ok;
    return await res.close();
  }

  @override
  ActivateUserController get newInstance => ActivateUserController();
}
