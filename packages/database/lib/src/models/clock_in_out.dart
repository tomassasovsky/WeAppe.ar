part of 'models.dart';

/// {@template logged_time_model}
/// The model for the logged time.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class LoggedTime extends DBModel<LoggedTime> {
  /// {@macro logged_time_model}
  LoggedTime() : super(Database().loggedTime);

  factory LoggedTime.fromJson(Map<String, dynamic> json) =>
      _$LoggedTimeFromJson(json);

  late ObjectId _userId;
  late ObjectId _organizationId;
  late Timestamp _start;

  /// When the clock out was logged.
  Timestamp? end;

  /// The time spent in minutes.
  int? durationInMiliseconds;

  /// The clock in time, in a [DateTime] format.
  DateTime get clockInAsDateTime =>
      DateTime.fromMillisecondsSinceEpoch(_start.seconds * 1000);

  /// The clock out time, in a [DateTime] format.
  DateTime? get clockOutAsDateTime => end == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(end!.seconds * 1000);

  /// Inserts a new instance of [LoggedTime] in the database.
  /// Returns the [WriteResult] of the insertion.
  Future<WriteResult> clockIn({
    required ObjectId userId,
    required ObjectId organizationId,
  }) async {
    _organizationId = organizationId;
    _userId = userId;
    _start = Timestamp();

    // queues the clock-ins
    return _userQueue.addToQueue<WriteResult>(
      _userId,
      save,
    );
  }

  /// Clocks out the user.
  /// Returns the [WriteResult] of the clock-out.
  Future<WriteResult> clockOut() async {
    // TODO(tomassasovsky): implement no clock-out if the user is not clocked-in
    end = Timestamp();
    durationInMiliseconds = (end!.seconds - _start.seconds).abs();
    return save();
  }

  /// Returns the latest [LoggedTime] of the user.
  /// Returns `null` if the user has never clocked-in.
  Future<LoggedTime?> last({
    required ObjectId userId,
    required ObjectId organizationId,
  }) async {
    final loggedTime = await findOne(
      where
        ..eq('userId', _userId)
        ..eq('organizationId', _organizationId)
        ..sortBy('clockIn', descending: true),
    );

    return loggedTime;
  }

  static final _userQueue = UniqueQueues();

  @override
  LoggedTime fromJson(Map<String, dynamic> json) => _$LoggedTimeFromJson(json);

  @override
  Map<String, dynamic> toJson({bool standardEncoding = false}) =>
      _$LoggedTimeToJson(this, standardEncoding);

  /// A generic model for the logged time.
  /// Allows access to the utilities provided by the [DBModel] class.
  static LoggedTime get generic => _$LoggedTimeGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$LoggedTimeJsonSchema;
}
