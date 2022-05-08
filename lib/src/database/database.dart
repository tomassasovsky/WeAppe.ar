import 'dart:async';

import 'package:backend/backend.dart';
import 'package:backend/src/user/models/refresh_token.dart';
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

  late Db _db;

  DbCollection get usersCollection => _db.collection('users');
  DbCollection get refreshTokensCollection => _db.collection('refreshTokens');
  DbCollection get organizationsCollection => _db.collection('organizations');
  DbCollection get clockInOutCollection => _db.collection('clockInOut');
  DbCollection get invitesCollection => _db.collection('invites');

  Future<void> open() async {
    await _db.open();

    // create the collections with validators
    await _db.createCollection(
      'users',
      createCollectionOptions: CreateCollectionOptions(validator: User.generic.jsonSchema),
    );
    await _db.createCollection(
      'refreshTokens',
      createCollectionOptions: CreateCollectionOptions(validator: RefreshTokenDB.generic.jsonSchema),
    );
    await _db.createCollection(
      'organizations',
      createCollectionOptions: CreateCollectionOptions(validator: Organization.generic.jsonSchema),
    );
    await _db.createCollection(
      'clockInOut',
      createCollectionOptions: CreateCollectionOptions(validator: ClockInOut.generic.jsonSchema),
    );
    await _db.createCollection(
      'invites',
      createCollectionOptions: CreateCollectionOptions(validator: Invite.generic.jsonSchema),
    );

    // create indexes
    await usersCollection.createIndex(key: 'email', unique: true);
    await organizationsCollection.createIndex(
      keys: <String, int>{
        'admin': 1,
        'name': 1,
      },
      unique: true,
    );
  }

  FutureOr close() => _db.close();
}
