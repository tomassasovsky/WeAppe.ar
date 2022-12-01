import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  factory DatabaseService([Db? db]) {
    if (db != null) {
      _inst._db = db;
    }
    return _inst;
  }

  DatabaseService._internal();

  static final DatabaseService _inst = DatabaseService._internal();

  Db? _db;

  DbCollection get usersCollection => _db!.collection('users');
  DbCollection get userActivationCollection =>
      _db!.collection('userActivation');
  DbCollection get refreshTokensCollection => _db!.collection('refreshTokens');
  DbCollection get organizationsCollection => _db!.collection('organizations');
  DbCollection get recordsCollection => _db!.collection('records');
  DbCollection get invitesCollection => _db!.collection('invites');

  Future<void> open() async {
    await _db!.open();

    // create the collections
    Future.wait([
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

  FutureOr<dynamic> close() => _db!.close();
}
