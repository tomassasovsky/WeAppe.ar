part of 'models.dart';

/// {@template user_model}
/// The model for the Users.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  /// {@macro user_model}
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.country,
    this.city,
    this.imageUrl,
    this.organizations,
    this.activationDate,
  }) : super(Database().users);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// The first name of the user.
  String firstName;

  /// The last name of the user.
  String lastName;

  /// The email of the user.
  String email;

  /// The password of the user.
  String password;

  /// The country of the user.
  String? country;

  /// The city of the user.
  String? city;

  /// The image of the user.
  String? imageUrl;

  /// The organizations of the user.
  List<ObjectId>? organizations;

  /// The activation date of the user.
  Timestamp? activationDate;

  /// Whether the user is activated or not.
  /// Based purely on the activation date.
  bool get isActive => activationDate != null;

  DateTime? get _activationDateAsDateTime => activationDate == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(activationDate!.seconds * 1000);

  /// Activates the user.
  FutureOr<WriteResult> activate() async {
    activationDate = Timestamp();
    return await save();
  }

  @override
  Map<String, dynamic> toJson({
    bool showPassword = true,
    bool standardEncoding = false,
  }) =>
      _$UserToJson(
        this,
        showPassword: showPassword,
        standardEncoding: standardEncoding,
      );

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  /// A generic model for the user.
  /// Allows access to the utilities provided by the [DBModel] class.
  static User get generic => _$UserGeneric;

  @override
  Map<String, dynamic> get jsonSchema => _$UserJsonSchema;
}
