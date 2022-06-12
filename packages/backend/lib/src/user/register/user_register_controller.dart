part of 'register.dart';

class UserRegisterController extends Controller<UserRegisterController> {
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String password;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) {
    firstName = req.store.get<String>('firstName');
    lastName = req.store.get<String>('lastName');
    email = req.store.get<String>('email');
    password = req.store.get<String>('password');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    try {
      final foundUser = await User.generic.findOne(where.eq('email', email));

      if (foundUser?.isActive ?? false) {
        res.statusCode = HttpStatus.ok;
        return await res.close();
      }

      await foundUser?.delete();

      final hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());
      final user = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: hashedPassword,
      );

      final result = await user.save();

      if (result.isFailure) {
        throw AlfredException(403, {
          'message': 'Could not create user',
        });
      }

      final userActivation = UserActivation(
        activationKey: Uuid().v4(),
        userId: user.id!,
      );

      final activationResult = await userActivation.save();
      if (activationResult.isFailure) {
        throw AlfredException(500, {
          'message': 'Could not create user activation',
        });
      }

      final emailSent =
          await EmailSenderService().sendRegisterVerificationEmail(
        to: user.email,
        activationKey: userActivation.activationKey,
      );

      if (!emailSent) {
        throw AlfredException(500, {
          'message': 'Could not send activation email',
        });
      }

      res.statusCode = HttpStatus.ok;
      await res.close();
    } on AlfredException {
      rethrow;
    } catch (e) {
      throw AlfredException(500, {
        'message': 'an unknown error occurred',
      });
    }
  }

  @override
  UserRegisterController get newInstance => UserRegisterController();
}
