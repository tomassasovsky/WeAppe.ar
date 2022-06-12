import 'dart:async';

import 'package:backend/backend.dart';
import 'package:mongo_dart/mongo_dart.dart';

export 'models/clock_in_out.dart';
export 'models/invite.dart';
export 'models/organization.dart';
export 'models/refresh_token.dart';
export 'models/user_activation.dart';
export 'models/user.dart';

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

  DbCollection get users => _db.collection('users');
  DbCollection get userActivation => _db.collection('userActivation');
  DbCollection get refreshTokens => _db.collection('refreshTokens');
  DbCollection get organizations => _db.collection('organizations');
  DbCollection get loggedTime => _db.collection('clockInOut');
  DbCollection get invites => _db.collection('invites');

  Future<void> open() async {
    await _db.open();

    /// register collections
    await Future.wait([
      User.generic.registerCollection(_db, 'users'),
      RefreshTokenDB.generic.registerCollection(_db, 'refreshTokens'),
      Organization.generic.registerCollection(_db, 'organizations'),
      LoggedTime.generic.registerCollection(_db, 'clockInOut'),
      Invite.generic.registerCollection(_db, 'invites'),
      UserActivation.generic.registerCollection(_db, 'userActivation'),
    ]);

    // create indexes
    await users.createIndex(key: 'email', unique: true);
    await organizations.createIndex(
      keys: <String, int>{
        'admin': 1,
        'name': 1,
      },
      unique: true,
    );
  }

  FutureOr close() => _db.close();
}
