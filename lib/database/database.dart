// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

/// {@template database_service}
/// This class is responsible for connecting to the database and
/// closing the connection.
/// {@endtemplate}
class DatabaseService {
  /// {@macro database_service}
  factory DatabaseService([Db? db]) {
    if (db != null) {
      _inst._db = db;
    }
    return _inst;
  }

  DatabaseService._internal();

  static final DatabaseService _inst = DatabaseService._internal();

  /// The database connection. We use a nullable variable to handle models
  /// in the front end withouth a database connection.
  Db? _db;

  /// The user collection.
  DbCollection get usersCollection => _db!.collection('users');

  /// The user activation collection.
  DbCollection get userActivationCollection =>
      _db!.collection('userActivation');

  /// The refresh token collection.
  DbCollection get refreshTokensCollection => _db!.collection('refreshTokens');

  /// The organizations collection.
  DbCollection get organizationsCollection => _db!.collection('organizations');

  /// The records collection.
  DbCollection get recordsCollection => _db!.collection('records');

  /// The invites collection.
  DbCollection get invitesCollection => _db!.collection('invites');

  /// This method is responsible for connecting to the database.
  Future<void> open() async {
    await _db!.open();

    // create the collections
    await Future.wait([
      _db!.createCollection('users'),
      _db!.createCollection('refreshTokens'),
      _db!.createCollection('organizations'),
      _db!.createCollection('userActivation'),
      _db!.createCollection('records'),
      _db!.createCollection('invites'),
      // create indexes
      usersCollection.createIndex(key: 'email', unique: true),
      organizationsCollection.createIndex(
        keys: <String, int>{
          'admin': 1,
          'name': 1,
        },
        unique: true,
      ),
    ]);
  }

  /// This method is responsible for closing the database connection.
  FutureOr<dynamic> close() => _db!.close();
}
