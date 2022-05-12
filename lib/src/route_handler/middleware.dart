part of 'route_handler.dart';

abstract class Middleware<T extends RouteHandler<T>> with RouteHandler<T> {
  @literal
  const Middleware();
}
