import 'dart:async';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

FutureOr<void> main() async {
  print('Starting server...');
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) DotEnv().load();

  final db = await mongo.Db.create(Constants.mongoConnectionString);

  final dbService = Database(db);
  await dbService.open();

  print('Connected to database.');

  final server = Server();
  await server.init(printRoutes: false);
}
