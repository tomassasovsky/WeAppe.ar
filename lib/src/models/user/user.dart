import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:weappear_backend/database/database.dart';
import 'package:weappear_backend/database/db_model.dart';
import 'package:weappear_backend/extensions/datetime.dart';
import 'package:weappear_backend/src/utils/object_parsers.dart';

part 'user.g.dart';

/// The gender of the user. The default value is helicopter.
enum Gender {
  /// The user is a Male.
  @JsonValue('male')
  male,

  /// The user is a Female
  @JsonValue('female')
  female,

  /// The user is a Helicopter, Helicopter 🚁.
  @JsonValue('helicopter')
  helicopter;

  /// Returns a gender with the given [String] value.
  factory Gender.fromString(String? value) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.helicopter;
    }
  }
}

/// {@template user}
/// This class represents a user in the database.
/// {@endtemplate}
@JsonSerializable(explicitToJson: true)
class User extends DBModel<User> {
  /// {@macro user}
  User({
    ObjectId? id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.description,
    this.location,
    this.imageUrl,
    this.organizations,
    this.activationDate,
    this.gender = Gender.helicopter,
    this.lang = 'en_US',
    this.timezone = 'GMT',
  }) {
    try {
      super.collection = DatabaseService().usersCollection;
      super.id = id;
    } catch (_) {}
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// The first name of the user
  String firstName;

  /// The last name of the user.
  String lastName;

  /// The email of the user.
  String email;

  /// The password of the user.
  ///
  /// The password is not returned in responses and is hashed before storing it.
  String? password;

  /// The description of the user.
  String? description;

  /// The location of the user.
  String? location;

  /// The image url of the user.
  String? imageUrl;

  /// The language of the user. The default value is `en_US`.
  String lang;

  /// The timezone of the user. The default value is `GMT`.
  String timezone;

  /// The gender of the user. The default value is [Gender.helicopter].
  Gender gender;

  /// The list of organizations the user is a member of.
  @JsonKey(fromJson: objectIdsFromJsonList, includeIfNull: false)
  List<ObjectId>? organizations;

  /// The date the user was activated.
  @BsonTimestampNullConverter()
  Timestamp? activationDate;

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// This method returns the data of the user as a [Map] that can be returned
  /// in a response.
  Map<String, dynamic> get toJsonResponse {
    final response = toJson()..remove('password');
    response['activationDate'] = activationDate?.toDateTime().toIso8601String();
    return response;
  }

  /// This method is used to create a new user instance with new data in it.
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? description,
    String? location,
    String? imageUrl,
    Gender? gender,
    String? lang,
    String? timezone,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      activationDate: activationDate,
      lang: lang ?? this.lang,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  User fromJson(Map<String, dynamic> json) => User.fromJson(json);

  /// This method returns a generic User.
  static User get generic {
    return User(
      firstName: '',
      lastName: '',
      email: '',
    );
  }
}
