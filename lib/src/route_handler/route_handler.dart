import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:backend/backend.dart';
import 'package:meta/meta.dart';
import 'package:reflectable/reflectable.dart';

part 'controller.dart';
part 'middleware.dart';

class RouteHandlerReflector extends Reflectable {
  const RouteHandlerReflector()
      : super(
          invokingCapability,
          typingCapability,
          newInstanceCapability,
          reflectedTypeCapability,
        );
}

const reflector = RouteHandlerReflector();

@reflector
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
    final mirror = reflector.reflectType(runtimeType) as ClassMirror;
    return mirror.newInstance('', <dynamic>[]) as RouteHandler;
  }
}
