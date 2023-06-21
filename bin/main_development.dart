import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/src/router.dart';
import 'package:weappear_backend/src/utils/utils.dart';

void main() async {
  stdout.write('Starting server...\n');
  final envFileExists = File.fromUri(Uri.parse('.env')).existsSync();
  if (envFileExists) dotenv.load();

  final db = await mongo.Db.create(Constants.mongoConnectionString);
  final dbService = DatabaseService(db);
  final handler = SwaggerUI('spec/swagger.yaml', title: 'Swagger Test');
  tz.initializeTimeZones();
  await dbService.open();

  stdout.write('Starting server at localhost:8080. \n');
  withHotreload(() async {
    // await io.serve(
    //   handler,
    //   'localhost',
    //   8000,
    //   poweredByHeader: 'WeAppear',
    // );
    return io.serve(
      WeAppearRouter().appPipeline,
      'localhost',
      8000,
      poweredByHeader: 'WeAppear',
    );
  });
}
