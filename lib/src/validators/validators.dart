import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:alfredito/alfredito.dart';
import 'package:backend/backend.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

part 'auth_validator.dart';

class Validators {
  static RegExp get mongoIdRegExp => RegExp(r'^[a-fA-F0-9]{24}$');
  static RegExp get uuidRegExp => RegExp('[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');

  static RegExp get passwordRegExp => RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp get emailRegExp => RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
      );

  static RegExp get urlRegExp => RegExp(r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?', caseSensitive: false);
}
