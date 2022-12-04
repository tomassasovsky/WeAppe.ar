import 'dart:async';
import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shelf/shelf_io.dart' as io;
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/src/router.dart';
import 'package:weappear_backend/src/utils/utils.dart';

void main() {
  runZonedGuarded(
    () async {
      stdout.write('Starting server...\n');
      final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
      if (envFileExists) dotenv.load();

      final db = await mongo.Db.create(Constants.mongoConnectionString);

      final dbService = DatabaseService(db);

      await dbService.open();

      stdout
        ..write('Connected to database.')
        ..write('Starting server at localhost:8080. \n');
      await io.serve(
        WeAppearRouter().appPipeline,
        'localhost',
        8080,
        poweredByHeader: 'WeAppear',
      );
    },
    (error, stack) => stdout.write(
      'An error has occured:\n$error\n$stack',
    ),
  );
}
