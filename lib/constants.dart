import 'dart:io';

import 'package:dotenv/dotenv.dart';

abstract class Constants {
  static const usersCollection = 'users';
  static const refreshTokensCollection = 'refreshTokens';
  static const organizationsCollection = 'organization';
  static final jwtRefreshSignature =
      (Platform.environment['JWT_REFRESH_TOKEN_SIGNATURE'] ??
          env['JWT_REFRESH_TOKEN_SIGNATURE'])!;
  static final jwtAccessSignature =
      (Platform.environment['JWT_ACCESS_TOKEN_SIGNATURE'] ??
          env['JWT_ACCESS_TOKEN_SIGNATURE'])!;
  static final mongoConnectionString =
      (Platform.environment['MONGO_CONNECTION'] ?? env['MONGO_CONNECTION'])!;
  static final imgurClientId =
      (Platform.environment['IMGUR_CLIENT_ID'] ?? env['IMGUR_CLIENT_ID'])!;

  static final passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static final emailRegExp = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
  );
}
