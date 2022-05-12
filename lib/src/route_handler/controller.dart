part of 'route_handler.dart';

abstract class Controller<T extends RouteHandler<T>> with RouteHandler<T> {
  @literal
  const Controller();
}
