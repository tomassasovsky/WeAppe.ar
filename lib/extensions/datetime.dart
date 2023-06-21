import 'package:mongo_dart/mongo_dart.dart';

/// Convinient extension that allows to convert [DateTime] to [Timestamp] easily.
extension ToTimestamp on DateTime {
  /// Converts [DateTime] to [Timestamp].
  Timestamp toTimestamp() => Timestamp(millisecondsSinceEpoch ~/ 1000);
}

/// Convinient extension that allows to convert [Timestamp] to [DateTime] easily.
extension ToDateTime on Timestamp {
  /// Converts [Timestamp] to [DateTime].
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}
