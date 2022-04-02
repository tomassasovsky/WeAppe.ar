import 'package:backend/src/database/database.dart';
import 'package:backend/src/user/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UsersService {
  UsersService(this.dbService);

  final DatabaseService dbService;

  Future<User?> findUserByEmail({
    required String email,
  }) async {
    final user = await dbService.usersCollection.findOne(where.eq('email', email));

    if (user == null || user.isEmpty) {
      return null;
    }

    return User.fromJson(user);
  }
}
