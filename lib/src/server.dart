import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:alfredito/alfredito.dart';
import 'package:backend/backend.dart';

class Server {
  FutureOr<void> init({bool printRoutes = true}) async {
    // initialize alfredito:
    _app = Alfredito(
      simultaneousProcessing: 15000,
      logLevel: LogType.error,
      onNotFound: _onNotFoundHandler,
      onInternalError: _errorHandler,
    )
      ..all('*', cors())
      ..registerRoutes(routes);

    if (printRoutes) _app?.printRoutes();

    // start the alfred server:
    await _app?.listen(port);
    print('Server started on: ${Constants.host}');
  }

  Future<void>? close() async {
    try {
      await _app?.close();
    } catch (_) {}
  }

  FutureOr<dynamic> _errorHandler(HttpRequest req, HttpResponse res) {
    res.statusCode = 500;
    return {'message': 'error not handled'};
  }

  FutureOr<dynamic> _onNotFoundHandler(HttpRequest req, HttpResponse res) {
    res.statusCode = 404;
    return {'message': '${req.requestedUri.path} not found'};
  }

  Alfred? _app;
  int get port => _app?.server?.port ?? 8080;
}
