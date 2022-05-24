import 'dart:async';

import 'package:backend/src/database/database.dart';
import 'package:backend/src/user/models/refresh_token.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TokensService {
  TokensService(this.dbService);

  final DatabaseService dbService;

  FutureOr<WriteResult> addToDatabase(dynamic userId, String refreshToken) {
    return dbService.refreshTokensCollection.insertOne(
      <String, dynamic>{
        'userId': userId,
        'refreshToken': refreshToken,
      },
    );
  }

  FutureOr<WriteResult> deleteFromDatabase(String token) {
    return dbService.refreshTokensCollection.deleteOne(
      where.eq('refreshToken', token),
    );
  }

  FutureOr<RefreshTokenDB?> findById(dynamic id) async {
    final _id = (id is ObjectId) ? id : ObjectId.parse(id as String);

    final result = await dbService.refreshTokensCollection.findOne(
      where.id(_id),
    );

    if (result == null || result.isEmpty) {
      return null;
    }

    return RefreshTokenDB.fromJson(result);
  }

  FutureOr<RefreshTokenDB?> findByTokenValue(String token) async {
    final result = await dbService.refreshTokensCollection.findOne(
      where.eq('refreshToken', token),
    );

    if (result == null || result.isEmpty) {
      return null;
    }

    return RefreshTokenDB.fromJson(result);
  }
}
