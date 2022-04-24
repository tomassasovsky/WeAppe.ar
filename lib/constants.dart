import 'dart:io';
import 'package:dotenv/dotenv.dart';

abstract class Constants {
  static const usersCollection = 'users';
  static const refreshTokensCollection = 'refreshTokens';
  static const organizationsCollection = 'organization';
  static const clockInOutsCollection = 'clockInOuts';
  static final jwtRefreshSignature = (Platform.environment['JWT_REFRESH_TOKEN_SIGNATURE'] ?? env['JWT_REFRESH_TOKEN_SIGNATURE'])!;
  static final jwtAccessSignature = (Platform.environment['JWT_ACCESS_TOKEN_SIGNATURE'] ?? env['JWT_ACCESS_TOKEN_SIGNATURE'])!;
  static final mongoConnectionString = (Platform.environment['MONGO_CONNECTION'] ?? env['MONGO_CONNECTION'])!;
  static final imgurClientId = (Platform.environment['IMGUR_CLIENT_ID'] ?? env['IMGUR_CLIENT_ID'])!;
  static final inviteEmailAccount = (Platform.environment['INVITE_EMAIL_ACCOUNT'] ?? env['INVITE_EMAIL_ACCOUNT'])!;
  static final inviteEmailUserName = (Platform.environment['INVITE_EMAIL_USER_NAME'] ?? env['INVITE_EMAIL_USER_NAME'])!;
  static final inviteEmailPassword = (Platform.environment['INVITE_EMAIL_PASSWORD'] ?? env['INVITE_EMAIL_PASSWORD'])!;
  static final inviteEmailHost = (Platform.environment['INVITE_EMAIL_HOST'] ?? env['INVITE_EMAIL_HOST'])!;
  static final host = (Platform.environment['HOST'] ?? env['HOST'])!;
  static final inviteEmailPort = int.tryParse(
        Platform.environment['INVITE_EMAIL_PORT'] ?? env['INVITE_EMAIL_PORT'] ?? '',
      ) ??
      465;
}
