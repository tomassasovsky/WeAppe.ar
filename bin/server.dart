import 'dart:async';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:mongo_dart/mongo_dart.dart' as mongo;

FutureOr<void> main() async {
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) dotenv.load();

  final db = await mongo.Db.create(Constants.mongoConnectionString);

  final dbService = DatabaseService(db);
  Services(dbService);

  await dbService.open();

  final server = Server();
  await server.init();
}
