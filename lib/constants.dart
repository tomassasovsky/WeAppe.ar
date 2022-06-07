import 'dart:io';
import 'package:dotenv/dotenv.dart';

abstract class Constants {
  static const usersCollection = 'users';
  static const refreshTokensCollection = 'refreshTokens';
  static const organizationsCollection = 'organization';
  static const clockInOutsCollection = 'clockInOuts';

  static final jwtRefreshSignature = (Platform.environment['JWT_REFRESH_TOKEN_SIGNATURE'] ?? env['JWT_REFRESH_TOKEN_SIGNATURE'] ?? '');
  static final jwtAccessSignature = (Platform.environment['JWT_ACCESS_TOKEN_SIGNATURE'] ?? env['JWT_ACCESS_TOKEN_SIGNATURE'] ?? '');
  static final mongoConnectionString = (Platform.environment['MONGO_CONNECTION'] ?? env['MONGO_CONNECTION'] ?? '');
  static final imgurClientId = (Platform.environment['IMGUR_CLIENT_ID'] ?? env['IMGUR_CLIENT_ID'] ?? '');
  static final serverEmailAccount = (Platform.environment['SERVER_EMAIL_ACCOUNT'] ?? env['SERVER_EMAIL_ACCOUNT'] ?? '');
  static final serverEmailUserName = (Platform.environment['SERVER_EMAIL_USER_NAME'] ?? env['SERVER_EMAIL_USER_NAME'] ?? '');
  static final serverEmailPassword = (Platform.environment['SERVER_EMAIL_PASSWORD'] ?? env['SERVER_EMAIL_PASSWORD'] ?? '');
  static final serverEmailHost = (Platform.environment['SERVER_EMAIL_HOST'] ?? env['SERVER_EMAIL_HOST'] ?? '');
  static final serverEmailPort = int.tryParse(Platform.environment['SERVER_EMAIL_PORT'] ?? env['SERVER_EMAIL_PORT'] ?? '') ?? 465;
  static final host = (Platform.environment['HOST'] ?? env['HOST'] ?? '');
  static final redirectHomepage = (Platform.environment['REDIRECT_HOMEPAGE'] ?? env['REDIRECT_HOMEPAGE'] ?? '');
}
