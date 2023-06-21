import 'dart:io';
import 'package:dotenv/dotenv.dart';

/// {@template constants}
/// This abstract class contains all the constants used in the project, including
/// the environment variables.
/// {@endtemplate}
abstract class Constants {
  /// The jwt refresh token signature.
  static final jwtRefreshSignature =
      Platform.environment['JWT_REFRESH_TOKEN_SIGNATURE'] ??
          env['JWT_REFRESH_TOKEN_SIGNATURE'] ??
          '';

  /// The jwt access token signature.
  static final jwtAccessSignature =
      Platform.environment['JWT_ACCESS_TOKEN_SIGNATURE'] ??
          env['JWT_ACCESS_TOKEN_SIGNATURE'] ??
          '';

  /// The connection string for the database.
  static final mongoConnectionString =
      Platform.environment['MONGO_CONNECTION'] ?? env['MONGO_CONNECTION'] ?? '';

  /// The email account used to send emails.
  static String get serverEmailAccount =>
      Platform.environment['SERVER_EMAIL_ACCOUNT'] ??
      env['SERVER_EMAIL_ACCOUNT'] ??
      '';

  /// The email username used to send emails.
  static final serverEmailUserName =
      Platform.environment['SERVER_EMAIL_USER_NAME'] ??
          env['SERVER_EMAIL_USER_NAME'] ??
          '';

  /// The email password used to send emails.
  static final serverEmailPassword =
      Platform.environment['SERVER_EMAIL_PASSWORD'] ??
          env['SERVER_EMAIL_PASSWORD'] ??
          '';

  /// The host of the email server.
  static final serverEmailHost = Platform.environment['SERVER_EMAIL_HOST'] ??
      env['SERVER_EMAIL_HOST'] ??
      '';

  /// The port of the email server.
  static final serverEmailPort = int.tryParse(
        Platform.environment['SERVER_EMAIL_PORT'] ??
            env['SERVER_EMAIL_PORT'] ??
            '',
      ) ??
      465;

  /// The host of the server.
  static final host = Platform.environment['HOST'] ?? env['HOST'] ?? '';

  /// The home page url.
  static final redirectHomepage = Platform.environment['REDIRECT_HOMEPAGE'] ??
      env['REDIRECT_HOMEPAGE'] ??
      '';

  /// The secret used to create the otp tokens.
  static final hotpSecret =
      Platform.environment['BGWZIDOJPYKNZJ2C'] ?? env['BGWZIDOJPYKNZJ2C'] ?? '';
}
