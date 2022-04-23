import 'dart:async';
import 'dart:mirrors';

import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';
import 'package:meta/meta.dart';

part 'controller.dart';
part 'middleware.dart';

abstract class RouteHandler {
  FutureOr<dynamic> defineVars(HttpRequest req, HttpResponse res) async {}

  // this is the method that is called when the route is called
  FutureOr<dynamic> call(HttpRequest req, HttpResponse res) async {
    final instance = _internalInstance();
    // this handles the request
    await instance.defineVars(req, res);
    req.validate();
    await instance.run(req, res);
  }

  FutureOr<dynamic> run(HttpRequest req, HttpResponse res);

  RouteHandler _internalInstance() {
    // this creates a new instance of the class
    final mirror = reflectClass(runtimeType);
    return mirror.newInstance(Symbol.empty, <dynamic>[]).reflectee as RouteHandler;
  }
}
