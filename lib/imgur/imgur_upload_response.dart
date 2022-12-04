part of 'imgur_client.dart';

///
ImgurUploadResponse imgurUploadResponseFromMap(String str) =>
    ImgurUploadResponse.fromMap(json.decode(str) as Map<String, dynamic>);

/// {@template imgur_upload_response}
/// This class represents the response from the Imgur API.
/// {@endtemplate}
class ImgurUploadResponse {
  /// {@macro imgur_upload_response}
  ImgurUploadResponse({
    this.status,
    this.success,
    this.data,
  });

  /// Creates a new [ImgurUploadResponse] from a [Map].
  factory ImgurUploadResponse.fromMap(Map<String, dynamic> map) {
    return ImgurUploadResponse(
      status: map['status'] as num?,
      success: map['success'] as bool?,
      data: map['data'] == null
          ? null
          : Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  /// The status of the response.
  final num? status;

  /// Whether the request was successful.
  final bool? success;

  /// The data of the response.
  final Data? data;
}

/// {@template data}
/// This class represents the data of the response from the Imgur API.
/// {@endtemplate}
class Data {
  /// {@macro data}
  Data({
    this.id,
    this.name,
    this.type,
    this.width,
    this.height,
    this.size,
    this.link,
  });

  /// Creates a new [Data] from a [Map].
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'] as String?,
      name: map['name'] as String?,
      type: map['type'] as String?,
      width: map['width'] as num?,
      height: map['height'] as num?,
      size: map['size'] as num?,
      link: map['link'] as String?,
    );
  }

  /// The id of the image.
  final String? id;

  /// The name of the image.
  final String? name;

  /// The type of the image.
  final String? type;

  /// The width of the image.
  final num? width;

  /// The height of the image.
  final num? height;

  /// The size of the image.
  final num? size;

  /// The link to the image.
  final String? link;
}
