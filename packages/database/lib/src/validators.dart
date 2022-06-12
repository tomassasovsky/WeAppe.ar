/// {@macro validators_model}
/// A helper class for validating the models.
class Validators {
  /// The regular expression for a MongoDB ID.
  static RegExp get mongoIdRegExp => RegExp(r'^[a-fA-F0-9]{24}$');

  /// The regular expression for a UUID.
  static RegExp get uuidRegExp =>
      RegExp('[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}');

  /// The regular expression for a password.
  /// The password must contain at least one uppercase letter,
  /// one lowercase letter, one number and one special character.
  /// The password must be at least 8 characters long, and 64 chars max.
  static RegExp get passwordRegExp =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,64}$');

  /// The regular expression for an email.
  static RegExp get emailRegExp => RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
      );

  /// The regular expression for a URL.
  static RegExp get urlRegExp => RegExp(
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
        caseSensitive: false,
      );
}
