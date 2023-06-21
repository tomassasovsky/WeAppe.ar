import 'dart:async';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

/// {@template db_model}
/// This class is the base class for all database models. It has all the methods
/// to handle all the CRUD operations we need.
/// {@endtemplate}
abstract class DBModel<T> {
  /// {@macro db_model}
  DBModel({this.collection, this.id});

  /// The id of the model in the database.
  @JsonKey(name: '_id', includeIfNull: false, fromJson: objectId)
  ObjectId? id;

  /// The collection of the model in the database.
  @JsonKey(ignore: true)
  DbCollection? collection;

  /// This method is responsible for inserting the model into the database, or
  /// updating it if it already exists.
  Future<WriteResult> save() async {
    if (id != null) {
      final modifier = ModifierBuilder();
      final json = toJson()..remove('_id');
      stdout
        ..write(toJson())
        ..write(json);
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

  /// This method is responsible of finding all the records in the database
  /// that match the given [query].
  Future<List<T>> find([dynamic query]) async {
    final data = await collection!.find(query).toList();
    return data.map<T>(fromJson).toList();
  }

  /// This method is responsible of retrieving the number of records in the
  /// database that match the given [query].
  Future<int> count([dynamic query]) async {
    return collection!.count(query);
  }

  /// This method is responsible of finding all the records in the database
  /// that match the given [query] via stream.
  Stream<T> findStream([dynamic query]) async* {
    await for (final item in collection!.find(query)) {
      yield fromJson(item);
    }
  }

  /// This method is responsible of finding the first record in the database
  /// that matches the given [query].
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

  /// This method is responsible of inserting records into the database with
  /// the given [data].
  Future<WriteResult> insertOne(Map<String, dynamic> data) async {
    return collection!.insertOne(data);
  }

  /// This method is responsible of finding the first record matching the given
  /// id as a [String].
  Future<T?> byId(String id) {
    return findOne(where.id(ObjectId.fromHexString(id)));
  }

  /// This method is responsible of finding the first record matching the given
  /// id as a [ObjectId].
  Future<T?> byObjectId(ObjectId id) {
    return findOne(where.id(id));
  }

  /// This method is responsible for deleting the model from the database.
  Future<void> delete() => collection!.remove(<String, dynamic>{'_id': id});

  /// This method is responsible for converting the model to a [Map].
  Map<String, dynamic> toJson();

  /// This method is responsible for converting the model from a [Map].
  T fromJson(Map<String, dynamic> json);
}
