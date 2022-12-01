import 'package:mongo_dart/mongo_dart.dart';
import 'package:json_annotation/json_annotation.dart';

List<ObjectId>? objectIdsFromJsonList(List<dynamic>? json) {
  return json?.cast<String>().map((e) => ObjectId.fromHexString(e)).toList();
}

ObjectId objectId(ObjectId id) {
  return id;
}

class BsonTimestampNullConverter implements JsonConverter<Timestamp?, dynamic> {
  const BsonTimestampNullConverter();

  @override
  Timestamp? fromJson(dynamic json) => json as Timestamp?;

  @override
  dynamic toJson(Timestamp? object) => object;
}

class BsonTimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const BsonTimestampConverter();

  @override
  Timestamp fromJson(dynamic json) => json as Timestamp;

  @override
  dynamic toJson(Timestamp object) => object;
}
