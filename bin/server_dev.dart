import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:recharge/recharge.dart';

final server = Server();

Future<void> main() async {
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) dotenv.load();

  final db = await mongo.Db.create(Constants.mongoConnectionString);

  final dbService = DatabaseService(db);
  Services(dbService);

  await dbService.open();

  final server = Server();
  await server.init();

  final recharge = Recharge(
    path: './lib',
    onReload: () async => runServer(),
  );
  await recharge.init();
}

Future<void>? runServer() async {
  await server.close();
  await server.init(printRoutes: false);
}
