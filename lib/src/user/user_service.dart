import 'dart:async';

import 'package:backend/src/database/database.dart';
import 'package:backend/src/user/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UsersService {
  UsersService(this.dbService);

  final DatabaseService dbService;

  FutureOr<User?> findUserByEmail({
    required String email,
  }) async {
    final user = await dbService.usersCollection.findOne(where.eq('email', email));

    if (user == null || user.isEmpty) {
      return null;
    }

    return User.fromJson(user);
  }

  FutureOr<User?> findUserById(
    String id,
  ) async {
    final user = await dbService.usersCollection.findOne(where.id(ObjectId.parse(id)));

    if (user == null || user.isEmpty) {
      return null;
    }

    return User.fromJson(user);
  }
}
