part of 'regenerate_access_token.dart';

class RegenerateAccessTokenController
    extends Controller<RegenerateAccessTokenController> {
  late final RefreshTokenDB refreshToken;

  @override
  FutureOr defineVars(HttpRequest req, HttpResponse res) {
    refreshToken = req.store.get('token');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) {
    final newAccessToken = JWT(
      {
        'userId': refreshToken.userId.$oid,
        'refreshTokenId': refreshToken.id?.$oid,
      },
      issuer: 'https://weappe.ar',
    ).sign(
      Constants.jwtAccessSignature,
      expiresIn: const Duration(days: 7),
    );

    res.json({
      'accessToken': newAccessToken,
    });
  }

  @override
  RegenerateAccessTokenController get newInstance =>
      RegenerateAccessTokenController();
}
