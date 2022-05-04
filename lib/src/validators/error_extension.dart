part of 'validators.dart';

/// Data structure to keep all request-related data
final errorPluginData = <HttpRequest, ErrorStore>{};

/// Integrates [ErrorStore] mechanism on [HttpRequest]
extension ErrorPlugin on HttpRequest {
  /// Returns the [ErrorStore] dedicated to this request.
  ErrorStore get errorStore {
    errorPluginData[this] ??= ErrorStore();
    return errorPluginData[this]!;
  }

  void validate() {
    final errors = errorStore.jsonErrors;
    if (errors.isNotEmpty) {
      throw AlfredException(400, {
        'errors': errors,
      });
    }
  }
}

class ErrorStore {
  ErrorStore();

  final _errors = <ValidationError>[];

  void add(ValidationError error) => _errors.add(error);

  List<ValidationError> get errors => _errors;

  List<Map<String, dynamic>> get jsonErrors => _errors.map((e) => e.toJson()).toList();
}

void errorPluginOnDoneHandler(HttpRequest req, HttpResponse res) {
  errorPluginData.remove(req);
}

class ValidationError {
  ValidationError({
    this.location,
    this.msg,
    this.param,
  });

  Map<String, String> toJson() {
    return <String, String>{
      if (location != null && (location?.isNotEmpty ?? false)) 'location': location!,
      if (msg != null && (msg?.isNotEmpty ?? false)) 'msg': msg!,
      if (param != null && (param?.isNotEmpty ?? false)) 'param': param!,
    };
  }

  final String? location;
  final String? msg;
  final String? param;
}
