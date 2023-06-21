import 'package:shelf/shelf.dart';

/// The headers that allow CORS.
Map<String, String> corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, HEAD',
  'Access-Control-Allow-Headers':
      'custId, appId, Origin, Content-Type, Cookie, X-CSRF-TOKEN, Accept, '
          'Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin, '
          'Access-Control-Allow-Credentials',
  'Access-Control-Allow-Credentials': 'true',
  'Access-Control-Expose-Headers':
      'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,'
          'X-Amz-Security-Token,locale',
  'Access-Control-Max-Age': '86400',
};

/// This method is in charge of adding the CORS headers to the response.
Middleware generateCorsMiddleware({
  Map<String, String>? defaultHeaders,
  List<String>? allowedOrigins,
  // List<String> validMethods = Null,
}) {
  final defaultHeadersList =
      defaultHeaders?.map((key, value) => MapEntry(key, [value]));

  final corsHeadersList = corsHeaders.map(
    (key, value) => MapEntry(key, [value]),
  );

  return (Handler handler) {
    return (Request request) async {
      if (allowedOrigins?.contains(request.headers['origin']) ?? false) {
        corsHeadersList['Access-Control-Allow-Origin'] = [
          request.headers['origin']!
        ];
      }

      final allHeaders = {...corsHeadersList, ...?defaultHeadersList};

      if (request.method == 'OPTIONS') {
        return Response.ok(null, headers: allHeaders);
      }

      final response = await handler(request);

      return response.change(
        headers: {
          ...allHeaders,
          ...response.headersAll,
        },
      );
    };
  };
}

/// Headers that are added to all the options responses.
Map<String, String> alwaysHeaders = {
  'Content-Type': 'application/json',
  ...corsHeaders,
};
