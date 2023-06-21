// ignore_for_file: avoid_catching_errors

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import 'package:weappear_backend/src/utils/utils.dart';

/// Easy to use extension that allow us to verify if the request has a valid
/// token.
extension TokenValid on String {
  /// Returns true if the token is valid.
  Response? get isValid => isTokenValid(Constants.jwtAccessSignature);

  /// Returns true if the refresh token is valid.
  Response? get isValidRefresh => isTokenValid(Constants.jwtRefreshSignature);

  /// Verifies if the token is valid.
  Response? isTokenValid(String token) {
    try {
      JWT.verify(
        this,
        SecretKey(token),
      );
      return null;
    } on JWTError {
      return Response(
        401,
        body: {
          'message': 'Invalid token',
        },
      );
    } on FormatException {
      return Response(
        401,
        body: {
          'message': 'Invalid token',
        },
      );
    }
  }
}
