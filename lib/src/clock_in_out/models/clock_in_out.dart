import 'package:backend/src/database/database.dart';
import 'package:backend/src/db_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'clock_in_out.g.dart';

@JsonSerializable(explicitToJson: true)
class ClockInOut extends DBModel<ClockInOut> {
  ClockInOut({
    required this.userId,
    required this.organizationId,
    required this.clockIn,
    this.clockOut,
    this.durationInMiliseconds,
  }) : super(DatabaseService().clockInOutCollection);

  factory ClockInOut.fromJson(Map<String, dynamic> json) => _$ClockInOutFromJson(json);

  final ObjectId userId;
  final ObjectId organizationId;
  final Timestamp clockIn;
  final Timestamp? clockOut;
  final int? durationInMiliseconds;

  @override
  ClockInOut fromJson(Map<String, dynamic> json) => _$ClockInOutFromJson(json);

  @override
  Map<String, dynamic> toJson({bool standardEncoding = false}) => _$ClockInOutToJson(this, standardEncoding);

  DateTime get clockInAsDateTime => DateTime.fromMillisecondsSinceEpoch(clockIn.seconds * 1000);
  DateTime? get clockOutAsDateTime => clockOut == null ? null : DateTime.fromMillisecondsSinceEpoch(clockOut!.seconds * 1000);

  static ClockInOut get generic {
    return ClockInOut(
      userId: ObjectId(),
      organizationId: ObjectId(),
      clockIn: Timestamp(DateTime.now().millisecondsSinceEpoch ~/ 1000),
    );
  }

  @override
  Map<String, dynamic> get jsonSchema => _$ClockInOutJsonSchema;
}
