import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// {@template db_model}
/// Class that represents a MongoDB model.
/// Contains the [DbCollection].
/// Provides helper methods to insert, update, delete, find, findOne, etc.
/// {@endtemplate}
abstract class DBModel<T> {
  /// {@macro db_model}
  DBModel(
    this.collection, {
    this.id,
  });

  /// The [id] that this instance is associated with (in the [collection]).
  @JsonKey(name: '_id', includeIfNull: false, fromJson: ObjectId.parse)
  ObjectId? id;

  /// The [DbCollection] that this model is associated with.
  @JsonKey(ignore: true)
  DbCollection collection;

  /// Save the model to the database.
  Future<WriteResult> save() async {
    if (id != null) {
      final modifier = ModifierBuilder();
      toJson().forEach(modifier.set);

      final result = await collection.updateOne(
        where.id(id!),
        modifier,
      );
      return result;
    } else {
      final payload = toJson();
      final result = await collection.insertOne(payload);
      final document = result.document;
      if (document != null) {
        id = result.document?['_id'] as ObjectId?;
      }
      return result;
    }
  }

  /// Finds all the documents in the [collection] that match the [selector]
  FutureOr<List<T>> find(SelectorBuilder selector) async {
    final data = await collection.modernFind(selector: selector).toList();
    return data.map<T>(fromJson).toList();
  }

  /// Finds the documents in the [collection] that match the [selector]
  Stream<T> findStream(SelectorBuilder selector) async* {
    await for (final item in collection.modernFind(selector: selector)) {
      yield fromJson(item);
    }
  }

  /// Finds the first document in the [collection] that match the [selector]
  FutureOr<T?> findOne(SelectorBuilder selector) async {
    final data = await collection.modernFindOne(selector: selector);
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

  /// Finds the document that matches the provided [id].
  /// [id] can be either a [String] or [ObjectId].
  FutureOr<T?> byId(dynamic id) {
    if (id is ObjectId) {
      return findOne(where.id(id));
    } else {
      return findOne(where.id(ObjectId.parse(id.toString())));
    }
  }

  /// Deletes this document from the [collection].
  FutureOr<void> delete() => collection.remove(<String, dynamic>{'_id': id});

  /// Registers the collection with the [jsonSchema] as a validator.
  /// This is used to validate the model before saving it to the database.
  Future<Map<String, Object?>> registerCollection(
    Db database,
    String name,
  ) async {
    return database.createCollection(
      name,
      createCollectionOptions: CreateCollectionOptions(validator: jsonSchema),
    );
  }

  /// Converts the model to a [Map] that can be saved to the database.
  Map<String, dynamic> toJson();

  /// Converts the [Map] to a model.
  T fromJson(Map<String, dynamic> json);

  /// The Schema that is used to validate the model.
  Map<String, dynamic> get jsonSchema;
}
