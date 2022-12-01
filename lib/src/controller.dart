import 'package:shelf_router/shelf_router.dart';

/// {@template controller}
/// A [Controller] is a class that is used to group routes together and register
/// them with a [Router] and derive the requests to the correct service.
/// {@endtemplate}
abstract class Controller {
  /// The path for this controller.
  String get path;

  final router = Router();
}
