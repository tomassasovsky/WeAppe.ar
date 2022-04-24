// ignore_for_file: no_duplicate_case_values

part of 'validators.dart';

enum Source {
  body,
  query,
  headers,
}

enum ErrorType {
  parameterNotFound,
  parameterTypeMismatch,
  customValidationFailed,
}

class InputVariableValidator<T> {
  InputVariableValidator(
    this.req,
    this.name, {
    this.source = Source.body,
    this.regExp,
    this.regExpErrorMessage,
    this.onEmpty,
  });

  final String name;
  final Source source;
  final HttpRequest req;
  final RegExp? regExp;
  final String? regExpErrorMessage;
  final T? onEmpty;

  Future<T> required() async {
    final dynamic value = await _parseParameter();

    if (value == null || (value is String && value.isEmpty)) {
      _addError(value, ErrorType.parameterNotFound);
      return _createInstanceOf();
    } else if ((T == num || T == int || T == double) && value is String) {
      final asNum = num.tryParse(value);
      if (asNum == null) {
        _addError(value, ErrorType.parameterTypeMismatch);
        return _createInstanceOf();
      }
      return asNum as T;
    } else if (value is! T) {
      _addError(value, ErrorType.parameterTypeMismatch);
      return _createInstanceOf();
    }

    if (value is String && regExp != null) {
      final isValid = regExp?.hasMatch(value) ?? true;
      if (!isValid) {
        _addError(value, ErrorType.customValidationFailed);
        return _createInstanceOf();
      }
    }

    return value;
  }

  Future<T?> optional() async {
    final dynamic value = await _parseParameter();

    if (value == null || (value is String && value.isEmpty)) {
      return null;
    } else if ((T == num || T == int || T == double) && value is String) {
      final asNum = num.tryParse(value);
      if (asNum == null) {
        _addError(value, ErrorType.parameterTypeMismatch);
        return null;
      }
      return asNum as T;
    } else if (value is! T) {
      _addError(value, ErrorType.parameterTypeMismatch);
      return null;
    }

    if (value is String && regExp != null) {
      final isValid = regExp?.hasMatch(value) ?? true;
      if (!isValid) {
        _addError(value, ErrorType.customValidationFailed);
        return null;
      }
    }

    return value;
  }

  FutureOr<dynamic> _parseParameter() async {
    dynamic value;
    switch (source) {
      case Source.body:
        final body = await req.bodyAsJsonMap;
        if (body.containsKey(name)) {
          value = body[name];
        }
        break;
      case Source.query:
        if (req.params.containsKey(name)) {
          value = req.params[name];
        }
        break;
      case Source.headers:
        if (req.headers.value(name) != null) {
          value = req.headers.value(name);
        }
        break;
    }
    return value;
  }

  void _addError(
    dynamic value,
    ErrorType errorType,
  ) {
    late final String errorMessage;
    switch (errorType) {
      case ErrorType.parameterNotFound:
        errorMessage = '$name is required';
        break;
      case ErrorType.customValidationFailed:
        errorMessage = regExpErrorMessage ?? 'validation failed';
        break;
      case ErrorType.parameterTypeMismatch:
        errorMessage = 'Parameter is not a valid $T';
        break;
    }
    req.errorStore.add(
      ValidationError(
        location: source.name,
        msg: errorMessage,
        param: name,
      ),
    );
  }

  T _createInstanceOf() {
    switch (T) {
      case String:
        return '' as T;
      case num:
        return 0 as T;
      case bool:
        return false as T;
      case DateTime:
        return DateTime.now() as T;
      case List:
        return <dynamic>[] as T;
      case Map:
        return <dynamic, dynamic>{} as T;
      default:
        return onEmpty!;
    }
  }
}
