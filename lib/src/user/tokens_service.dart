import 'package:backend/src/database/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TokensService {
  TokensService(this.dbService);

  final DatabaseService dbService;

  Future<WriteResult> addToDatabase(dynamic userId, String refreshToken) {
    return dbService.refreshTokensCollection.insertOne(
      <String, dynamic>{
        'userId': userId,
        'refreshToken': refreshToken,
      },
    );
  }
}
