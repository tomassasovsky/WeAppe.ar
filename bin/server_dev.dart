import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:recharge/recharge.dart';

Future<void> main() async {
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) DotEnv().load();

  final db = await mongo.Db.create(
    Constants.mongoConnectionString,
  );

  final dbService = Database(db);
  await dbService.open();

  final server = Server();
  await server.init();

  Future<void>? runServer() async {
    await server.close();
    await server.init(printRoutes: false);
  }

  final recharge = Recharge(
    path: './lib',
    onReload: () async => runServer(),
  );
  await recharge.init();
}
