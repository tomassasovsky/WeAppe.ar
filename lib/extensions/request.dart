import 'dart:convert';

import 'package:shelf/shelf.dart';

/// This extension let us access the body of a [Response] as a [Map] or as
/// a [String].
extension RequestBodyAccessorExtension on Request {
  /// The bearer token of the request.
  String? get token {
    try {
      return headers['Authorization']?.replaceFirst(
        'Bearer ',
        '',
      );
    } catch (_) {
      return null;
    }
  }

  /// Creates a new request with the given body.
  Request newRequest(Object? body) => Request(
        method,
        requestedUri,
        body: body,
        headers: headers,
        protocolVersion: protocolVersion,
        encoding: encoding,
        handlerPath: handlerPath,
        url: url,
      );
}

/// {@template request_body_accessor}
/// Reference class for different request body accessors.
/// Provides basic accessors like [asString] or [asJson].
///
/// You can extend on this class to add your own body parser.
///
/// Example:
/// ```dart
/// extension PersonAccessor on RequestBodyAccessor {
///   Future<Person> get asPerson async => Person.fromJson(await asJson);
/// }
/// ```
/// {@endtemplate}
class RequestBodyAccessor {
  /// {@macro request_body_accessor}
  RequestBodyAccessor(this.request);

  /// The [Request] that is being accessed.
  Request request;

  /// Returns the request body as a utf8 string
  Future<String> get asString async => request.readAsString();

  /// Returns the request body as json-decoded object, that can be either
  /// `Map<String, dynamic>` or `List<dynamic>`
  Future<dynamic> get asJson async => jsonDecode(await asString);

  /// Returns the request body as Map object.
  /// `Map<dynamic, dynamic>`
  Future<Map<String, dynamic>> get asMap async =>
      (jsonDecode(await asString) as Map).cast<String, dynamic>();

  /// Returns the request body as a class instance that is
  /// initialized by the provided [reviver].
  /// *Hint: The reviver function can't be factory constructor*
  Future<T> as<T>(T Function(Map<String, dynamic>) reviver) async =>
      Function.apply(reviver, [(await asJson)]) as T;

  /// Returns the request body as a binary stream.
  Stream<List<int>> get asBinary => request.read();
}
