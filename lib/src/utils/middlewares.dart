import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';
import 'package:weappear_backend/extensions/extensions.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template route_middleware}
/// This class has all the [Middleware]s that will be used in the routes.
/// {@endtemplate}
class Middlewares {
  static final log = Logger('Middleware log.');

  /// The [corsMiddleware] will be used to allow CORS in the API. It's important
  /// to note that this middleware will be used in all the routes.
  static Middleware corsMiddleware = generateCorsMiddleware(
    allowedOrigins: [
      'http://localhost:3200',
      'http://20.51.244.93/',
    ],
  );

  /// The [tokenMiddleware] is a method that is used to check if the request
  /// has a valid token.
  static Middleware tokenMiddleware = (Handler inner) {
    return (Request request) async {
      if (request.token == null) {
        return Response.unauthorized(
          'Token not found',
        );
      }

      try {
        JWT.verify(
          request.token!,
          SecretKey(Constants.jwtAccessSignature),
        );
      } on JWTExpiredError {
        /// If the token is expired, we will delete it from the database.
        // await UserODM().deleteToken(request.token!);

        return Response.unauthorized('Token expired');
      } catch (_) {
        return Response.unauthorized(
          'Invalid token',
        );
      }
      return inner(request);
    };
  };
}

/// This extension adds a nice [userId] getter to the [JWT] class.
extension UserId on JWT {
  /// Returns the user id from the payload.
  ObjectId get userId => ObjectId.fromHexString(
        (payload as Map)['userId'] as String,
      );
}
