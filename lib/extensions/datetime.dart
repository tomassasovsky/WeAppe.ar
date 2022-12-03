import 'package:mongo_dart/mongo_dart.dart';

extension ToTimestamp on DateTime {
  Timestamp toTimestamp() => Timestamp(millisecond ~/ 1000);
}
