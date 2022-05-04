import 'dart:async';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'server.reflectable.dart';

FutureOr<void> main() async {
  print('Starting server...');
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) dotenv.load();

  initializeReflectable();

  final db = await mongo.Db.create(Constants.mongoConnectionString);

  final dbService = DatabaseService(db);
  Services(dbService);

  await dbService.open();

  print('Connected to database.');

  final server = Server();
  await server.init(printRoutes: false);
}
