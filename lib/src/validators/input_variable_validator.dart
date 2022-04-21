part of 'validators.dart';

enum Source {
  body,
  query,
  headers,
}

enum ErrorType {
  parameterNotFound,
  parameterTypeMismatch,
}

class InputVariableValidator<T> {
  InputVariableValidator(
    this.req,
    this.name, {
    this.source = Source.body,
  });

  final String name;
  final Source source;
  final HttpRequest req;

  FutureOr<T> required() async {
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
    final message = errorType == ErrorType.parameterNotFound ? 'Parameter not found' : 'Parameter is not of type $T';
    req.errorStore.add(
      ValidationError(
        location: source.name,
        msg: message,
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
        final mirror = reflectClass(T);
        return mirror.newInstance(Symbol.empty, <dynamic>[]).reflectee as T;
    }
  }
}
