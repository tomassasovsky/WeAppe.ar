import 'package:mongo_dart/mongo_dart.dart';
import 'package:json_annotation/json_annotation.dart';

List<ObjectId>? objectIdsFromJsonList(List<dynamic>? json) {
  return json?.cast<String>().map((e) => ObjectId.fromHexString(e)).toList();
}

ObjectId objectId(dynamic id) {
  if (id is String) {
    return ObjectId.fromHexString(id);
  }
  return id as ObjectId;
}

class BsonTimestampNullConverter implements JsonConverter<Timestamp?, dynamic> {
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

class BsonTimestampConverter implements JsonConverter<Timestamp, dynamic> {
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
