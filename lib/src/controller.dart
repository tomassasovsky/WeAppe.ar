import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';

abstract class Controller {
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {}

  FutureOr<dynamic> call(HttpRequest req, HttpResponse res) async {
    await defineVars(req, res);
    req.validate();
    await run(req, res);
  }

  FutureOr<dynamic> run(HttpRequest req, HttpResponse res);
}
