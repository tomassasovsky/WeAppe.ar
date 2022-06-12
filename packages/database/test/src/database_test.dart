// ignore_for_file: prefer_const_constructors
import 'package:database/database.dart';
import 'package:test/test.dart';

void main() {
  group('Database', () {
    test('can be instantiated', () {
      expect(Database(), isNotNull);
    });
  });
}
