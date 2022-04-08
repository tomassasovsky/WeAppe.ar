import 'dart:io';

import 'package:backend/backend.dart';
import 'package:backend/src/database/database.dart';
import 'package:backend/src/server.dart';
import 'package:backend/src/services/services.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<void> main() async {
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) dotenv.load();

  final db = await Db.create(Constants.mongoConnectionString);

  final dbService = DatabaseService(db);
  final services = Services(dbService);

  GetIt.instance.registerSingleton(dbService);
  GetIt.instance.registerSingleton<Services>(services);

  await database.open();

  const server = Server();
  await server.init();

  await database.close();
}
