part of database;

/// {@template database}
/// The database class.
/// Provides getters for the database collections, and registers the
/// validators for the models.
/// 
/// The database is a singleton, and can be accessed using the [Database]
/// class.
/// {@endtemplate}
class Database {
  /// {@macro database}
  factory Database([Db? db]) {
    if (db != null) {
      _inst._db = db;
    }
    return _inst;
  }

  Database._internal();
  static final Database _inst = Database._internal();
  late Db _db;

  /// User's collection
  DbCollection get users => _db.collection('users');

  /// UserActivation's collection
  DbCollection get userActivation => _db.collection('userActivation');

  /// RefreshToken's collection
  DbCollection get refreshTokens => _db.collection('refreshTokens');

  /// Organization's collection
  DbCollection get organizations => _db.collection('organizations');

  /// LoggedTime's collection
  DbCollection get loggedTime => _db.collection('clockInOut');

  /// Invite's collection
  DbCollection get invites => _db.collection('invites');

  /// Open the database
  Future<void> open() async {
    await _db.open();

    /// register collections
    await Future.wait<dynamic>([
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

  /// Close the database
  FutureOr close() => _db.close();
}
