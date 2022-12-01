import 'dart:async';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

abstract class DBModel<T> {
  DBModel({this.collection, this.id});

  @JsonKey(name: '_id', includeIfNull: false, fromJson: objectId)
  ObjectId? id;

  @JsonKey(ignore: true)
  DbCollection? collection;

  Future<WriteResult> save() async {
    if (id != null) {
      final modifier = ModifierBuilder();
      final json = toJson()..remove('_id');
      stdout.write(toJson());
      stdout.write(json);
      json.forEach(modifier.set);

      final result = await collection!.updateOne(
        where.id(id!),
        modifier,
      );
      return result;
    } else {
      final payload = toJson();
      final result = await collection!.insertOne(payload);
      final document = result.document;
      if (document != null) {
        id = result.document?['_id'] as ObjectId?;
      }
      return result;
    }
  }

  Future<List<T>> find([dynamic query]) async {
    final data = await collection!.find(query).toList();
    return data.map<T>(fromJson).toList();
  }

  Stream<T> findStream([dynamic query]) async* {
    await for (final item in collection!.find(query)) {
      yield fromJson(item);
    }
  }

  Future<T?> findOne([dynamic query]) async {
    final data = await collection!.findOne(query);
    if (data != null) {
      if (data[r'\$err'] == null) {
        return fromJson(data);
      } else {
        throw Exception(data[r'\$err']);
      }
    } else {
      return null;
    }
  }

  Future<WriteResult> insertOne(Map<String, dynamic> data) async {
    return collection!.insertOne(data);
  }

  Future<T?> byId(String id) {
    return findOne(where.id(ObjectId.fromHexString(id)));
  }

  Future<T?> byObjectId(ObjectId id) {
    return findOne(where.id(id));
  }

  Future<void> delete() => collection!.remove(<String, dynamic>{'_id': id});

  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}
