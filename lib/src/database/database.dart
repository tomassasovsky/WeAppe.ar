import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  DatabaseService(this._db);

  final Db _db;

  DbCollection get usersCollection => _db.collection('users');
  DbCollection get refreshTokensCollection => _db.collection('refreshTokens');
  DbCollection get organizationsCollection => _db.collection('organizations');
  DbCollection get clockInOutCollection => _db.collection('clockInOut');

  Future open() => _db.open();
  Future close() => _db.close();
}

DatabaseService get database => GetIt.instance.get<DatabaseService>();
