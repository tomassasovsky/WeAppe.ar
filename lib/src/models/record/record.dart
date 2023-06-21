import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/extensions/datetime.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'record.g.dart';

/// {@template record}
/// This class represents a record model in the database.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class Record extends DBModel<Record> {
  /// {@macro record}
  Record({
    ObjectId? id,
    required this.userId,
    required this.organizationId,
    required this.clockIn,
    this.clockOut,
    this.durationInMiliseconds,
  }) {
    try {
      super.collection = DatabaseService().recordsCollection;
      super.id = id;
    } catch (_) {}
  }

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// The id of the user making a record.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  final ObjectId userId;

  /// The id of the organization to which the record belongs.
  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  final ObjectId organizationId;

  /// The time when the user clocked in.
  @BsonTimestampConverter()
  final Timestamp clockIn;

  /// The time when the user clocked out.
  @BsonTimestampNullConverter()
  final Timestamp? clockOut;

  /// The duration of the record in miliseconds.
  ///
  /// e.g. if the user clocked in at 9am and clocked out at 7pm, the duration
  /// would be 8 hours, or 28800000 miliseconds.
  final int? durationInMiliseconds;

  @override
  Record fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// This method is used to find if the user has an open record in the
  /// organization.
  Future<Record?> findOpenRecord({
    required String organizationId,
    required String userId,
  }) async =>
      findOne(
        where
            .eq('organizationId', organizationId)
            .eq(
              'userId',
              userId,
            )
            .eq(
              'clockOut',
              null,
            ),
      );

  /// This method is used to close the record.
  Future<Record> clockOutRecord() async {
    final miliseconds = DateTime.now().millisecondsSinceEpoch;
    final timestamp = Timestamp(miliseconds ~/ 1000);
    final difference = miliseconds - clockIn.seconds * 1000;
    final record = Record(
      id: id,
      userId: userId,
      organizationId: organizationId,
      clockIn: clockIn,
      clockOut: timestamp,
      durationInMiliseconds: difference,
    );
    await record.save();
    return record;
  }

  @override
  Map<String, dynamic> toJson() => _$RecordToJson(this);

  /// This method is used to get the record as a json response.
  Map<String, dynamic> get toJsonResponse {
    final json = toJson();
    json['clockIn'] = clockIn.toDateTime().toIso8601String();
    json['clockOut'] = clockOut?.toDateTime().toIso8601String();
    return json;
  }

  /// This method is used to get a generic record.
  static Record get generic {
    return Record(
      userId: ObjectId(),
      organizationId: ObjectId(),
      clockIn: Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000),
    );
  }
}
