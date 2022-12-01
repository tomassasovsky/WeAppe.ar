// import 'dart:async';
// import 'dart:io';

// import 'package:alcanza_backend/src/router.dart';
// import 'package:alcanza_backend/src/utils/environment.dart';
// import 'package:shelf/shelf_io.dart' as io;

// void main() {
//   runZonedGuarded(
//     () async {
//       stdout.write(
//           'Starting server at ${Environment().address}:${Environment().port}. \n');
//       await io.serve(
//         AlcanzaRouter().app,
//         Environment().address,
//         Environment().port,
//         poweredByHeader: 'Powered by C-Ven',
//       );
//     },
//     (error, stack) => stdout.write(
//       'An error has occured:\n$error\n$stack',
//     ),
//   );
// }
