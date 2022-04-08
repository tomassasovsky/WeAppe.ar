import 'package:backend/backend.dart';
import 'package:backend/src/clock_in_out/clock_in_out_service.dart';
import 'package:backend/src/database/database.dart';
import 'package:backend/src/imgur/imgur_client.dart';
import 'package:backend/src/organization/organization_service.dart';
import 'package:backend/src/user/tokens_service.dart';
import 'package:backend/src/user/user_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get_it/get_it.dart';

class Services {
  Services(this.dbService);

  final DatabaseService dbService;

  late final users = UsersService(dbService);
  late final tokens = TokensService(dbService);
  late final organizations = OrganizationService(dbService);
  late final clockInOuts = ClockInOutService(dbService);

  late final imgurClient = ImgurClient(Constants.imgurClientId);

  final jwtAccessSigner = SecretKey(Constants.jwtAccessSignature);
  final jwtRefreshSigner = SecretKey(Constants.jwtRefreshSignature);
}

Services get services => GetIt.instance.get<Services>();
