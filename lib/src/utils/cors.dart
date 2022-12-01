// ignore_for_file: constant_identifier_names, public_member_api_docs
//! CORS SETTINGS FILE

import 'package:shelf/shelf.dart';

const ACCESS_CONTROL_ALLOW_ORIGIN = 'Access-Control-Allow-Origin';
const ACCESS_CONTROL_EXPOSE_HEADERS = 'Access-Control-Expose-Headers';
const ACCESS_CONTROL_ALLOW_CREDENTIALS = 'Access-Control-Allow-Credentials';
const ACCESS_CONTROL_ALLOW_HEADERS = 'Access-Control-Allow-Headers';
const ACCESS_CONTROL_ALLOW_METHODS = 'Access-Control-Allow-Methods';
const ACCESS_CONTROL_MAX_AGE = 'Access-Control-Max-Age';

Map<String, String> corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, HEAD',
  'Access-Control-Allow-Headers':
      'custId, appId, Origin, Content-Type, Cookie, X-CSRF-TOKEN, Accept, '
          'Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin, '
          'Access-Control-Allow-Credentials',
  'Access-Control-Allow-Credentials': 'true',
  ACCESS_CONTROL_EXPOSE_HEADERS:
      'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,'
          'X-Amz-Security-Token,locale',
  ACCESS_CONTROL_MAX_AGE: '86400',
};

Middleware generateCorsMiddleware({
  Map<String, String>? defaultHeaders,
  List<String>? allowedOrigins,
  // List<String> validMethods = Null,
}) {
  final defaultHeadersList =
      defaultHeaders?.map((key, value) => MapEntry(key, [value]));

  final corsHeadersList =
      corsHeaders.map(((key, value) => MapEntry(key, [value])));

  return (Handler handler) {
    return (Request request) async {
      if (allowedOrigins?.contains(request.headers['origin']) ?? false) {
        corsHeadersList['Access-Control-Allow-Origin'] = [
          request.headers['origin']!
        ];
        print(corsHeadersList['Access-Control-Allow-Origin']);
      }

      final allHeaders = {...corsHeadersList, ...?defaultHeadersList};

      if (request.method == 'OPTIONS') {
        return Response.ok(null, headers: allHeaders);
      }

      final response = await handler(request);

      var workedResponse = response.change(
        headers: {
          ...allHeaders,
          ...response.headersAll,
        },
      );

      return workedResponse;
    };
  };
}

Map<String, String> alwaysHeaders = {
  'Content-Type': 'application/json',
  ...corsHeaders,
};
