import 'dart:async';

import 'package:backend/src/database/database.dart';
import 'package:mongo_dart/mongo_dart.dart';

class InviteService {
  const InviteService(this.dbService);

  final DatabaseService dbService;

  FutureOr<WriteResult> addToDatabase(Invite invite) async {
    invite.timestamp = Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    return dbService.invites.insertOne(
      invite.toJson(),
    );
  }

  FutureOr<Invite?> findInviteById(dynamic id) async {
    final objectId = (id is ObjectId) ? id : ObjectId.parse(id as String);

    final invite = await dbService.invites.findOne(
      where.id(objectId),
    );

    if (invite == null || invite.isEmpty) {
      return null;
    }

    return Invite.fromJson(invite);
  }

  FutureOr<WriteResult> deleteFromDatabase({
    required ObjectId inviteId,
  }) async {
    return dbService.invites.deleteOne(
      where.id(inviteId),
    );
  }

  FutureOr<Invite?> findByRefId(String refId) async {
    final invite = await dbService.invites.findOne(
      where.eq('refId', refId),
    );

    if (invite == null || invite.isEmpty) {
      return null;
    }

    return Invite.fromJson(invite);
  }
}
