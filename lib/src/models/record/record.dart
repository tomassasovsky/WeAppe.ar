import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'record.g.dart';

@JsonSerializable(explicitToJson: true)
class Record extends DBModel<Record> {
  Record({
    required this.userId,
    required this.organizationId,
    required this.clockIn,
    this.clockOut,
    this.durationInMiliseconds,
  }) : super(DatabaseService().recordsCollection);

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  final ObjectId userId;

  @JsonKey(includeIfNull: false, fromJson: ObjectId.parse)
  final ObjectId organizationId;

  @BsonTimestampConverter()
  final Timestamp clockIn;

  @BsonTimestampNullConverter()
  final Timestamp? clockOut;
  final int? durationInMiliseconds;

  @override
  Record fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Future<Record?> findOpenRecord({
    required String organizationId,
    required String userId,
  }) =>
      findOne(
        where.eq('organizationId', organizationId).eq('userId', userId),
      );

  DateTime get _clockInAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(clockIn.seconds * 1000);

  DateTime? get _clockOutAsDateTime => clockOut == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(clockOut!.seconds * 1000);

  @override
  Map<String, dynamic> toJson() => _$RecordToJson(this);

  Map<String, dynamic> get toJsonResponse {
    final json = toJson();
    json['clockIn'] = _clockInAsDateTime.toIso8601String();
    json['clockOut'] = _clockOutAsDateTime?.toIso8601String();
    return json;
  }

  DateTime get clockInAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(clockIn.seconds * 1000);
  DateTime? get clockOutAsDateTime => clockOut == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(clockOut!.seconds * 1000);

  static Record get generic {
    return Record(
      userId: ObjectId(),
      organizationId: ObjectId(),
      clockIn: Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000),
    );
  }
}
