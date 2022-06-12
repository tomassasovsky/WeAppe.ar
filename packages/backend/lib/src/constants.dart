import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

/// This class is used to get all the constants used in the backend.
/// It is used to get the values from the .env file
/// and from the environment variables.
abstract class Constants {
  /// The .env file varables.
  static final env = DotEnv()..load(['../.env']);

  /// The refresh token secret.
  static final jwtRefreshSignature = SecretKey(
    Platform.environment['JWT_REFRESH_TOKEN_SIGNATURE'] ??
        env['JWT_REFRESH_TOKEN_SIGNATURE'] ??
        '',
  );

  /// The access token secret.
  static final jwtAccessSignature = SecretKey(
    Platform.environment['JWT_ACCESS_TOKEN_SIGNATURE'] ??
        env['JWT_ACCESS_TOKEN_SIGNATURE'] ??
        '',
  );

  /// The mongo connection string.
  static final mongoConnectionString =
      Platform.environment['MONGO_CONNECTION'] ?? env['MONGO_CONNECTION'] ?? '';

  /// The IMGUR client id.
  static final imgurClientId =
      Platform.environment['IMGUR_CLIENT_ID'] ?? env['IMGUR_CLIENT_ID'] ?? '';

  /// The Server email address.
  static final serverEmailAccount =
      Platform.environment['SERVER_EMAIL_ACCOUNT'] ??
          env['SERVER_EMAIL_ACCOUNT'] ??
          '';

  /// The Server email username.
  static final serverEmailUserName =
      Platform.environment['SERVER_EMAIL_USER_NAME'] ??
          env['SERVER_EMAIL_USER_NAME'] ??
          '';

  /// The Server email password.
  static final serverEmailPassword =
      Platform.environment['SERVER_EMAIL_PASSWORD'] ??
          env['SERVER_EMAIL_PASSWORD'] ??
          '';

  /// The Server email host.
  static final serverEmailHost = Platform.environment['SERVER_EMAIL_HOST'] ??
      env['SERVER_EMAIL_HOST'] ??
      '';

  /// The Server email port.
  static final serverEmailPort = int.tryParse(
        Platform.environment['SERVER_EMAIL_PORT'] ??
            env['SERVER_EMAIL_PORT'] ??
            '',
      ) ??
      465;

  /// The url of the server.
  static final host = Platform.environment['HOST'] ?? env['HOST'] ?? '';

  /// Where the user should be redirected to when going to the [host] url.
  static final redirectHomepage = Platform.environment['REDIRECT_HOMEPAGE'] ??
      env['REDIRECT_HOMEPAGE'] ??
      '';
}
