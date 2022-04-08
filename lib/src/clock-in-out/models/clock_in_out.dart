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
  }) : super(database.clockInOutCollection);

  factory ClockInOut.fromJson(Map<String, dynamic> json) =>
      _$ClockInOutFromJson(json);

  final ObjectId userId;
  final ObjectId organizationId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final int? durationInMiliseconds;

  @override
  ClockInOut fromJson(Map<String, dynamic> json) => _$ClockInOutFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ClockInOutToJson(this);
}
