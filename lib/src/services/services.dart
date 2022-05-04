import 'package:backend/backend.dart';
import 'package:backend/src/user/tokens_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Services {
  factory Services([DatabaseService? databaseService]) {
    if (databaseService != null) {
      _inst.databaseService = databaseService;
    }
    return _inst;
  }

  Services._internal();

  static final Services _inst = Services._internal();

  late DatabaseService databaseService;

  late final users = UsersService(databaseService);
  late final tokens = TokensService(databaseService);
  late final organizations = OrganizationService(databaseService);
  late final clockInOuts = ClockInOutService(databaseService);
  late final invites = InviteService(databaseService);

  late final imgurClient = ImgurClient(Constants.imgurClientId);
  late final emailSender = EmailSenderService();

  final jwtAccessSigner = SecretKey(Constants.jwtAccessSignature);
  final jwtRefreshSigner = SecretKey(Constants.jwtRefreshSignature);
}
