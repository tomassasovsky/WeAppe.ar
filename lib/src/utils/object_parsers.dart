import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// This function parses a list of string to a list of [ObjectId].
List<ObjectId>? objectIdsFromJsonList(List<dynamic>? json) {
  return json?.cast<String>().map(ObjectId.fromHexString).toList();
}

/// This function parses a dynamic to an [ObjectId].
ObjectId objectId(dynamic id) {
  if (id is String) {
    return ObjectId.fromHexString(id);
  }
  return id as ObjectId;
}

/// {@template bson_timestamp_null_converter}
/// This class allow us to convert a [Timestamp]? to a [DateTime]? and vice versa
/// when we serialize and deserialize a json.
/// {@endtemplate}
class BsonTimestampNullConverter implements JsonConverter<Timestamp?, dynamic> {
  /// {@macro bson_timestamp_null_converter}
  const BsonTimestampNullConverter();

  @override
  Timestamp? fromJson(dynamic json) {
    if (json is String) {
      final date = DateTime.parse(json);
      return Timestamp(date.millisecondsSinceEpoch ~/ 1000, 0);
    }
    return json as Timestamp?;
  }

  @override
  dynamic toJson(Timestamp? object) => object;
}

/// {@template bson_timestamp_null_converter}
/// This class allow us to convert a [Timestamp] to a [DateTime] and vice versa
/// when we serialize and deserialize a json.
/// {@endtemplate}
class BsonTimestampConverter implements JsonConverter<Timestamp, dynamic> {
  /// {@macro bson_timestamp_converter}
  const BsonTimestampConverter();

  @override
  Timestamp fromJson(dynamic json) {
    if (json is String) {
      final date = DateTime.parse(json);
      return Timestamp(date.millisecondsSinceEpoch ~/ 1000, 0);
    }
    return json as Timestamp;
  }

  @override
  dynamic toJson(Timestamp object) => object;
}
