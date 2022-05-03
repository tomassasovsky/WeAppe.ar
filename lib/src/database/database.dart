import 'dart:async';

import 'package:backend/backend.dart';
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
    await _db.createCollection(
      'organizations',
      createCollectionOptions: CreateCollectionOptions(
        validator: Organization.generic.jsonSchema,
      ),
    );
  }

  FutureOr close() => _db.close();
}
