import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

part 'imgur_upload_response.dart';

/// {@template imgur_client}
/// This class is used as a singleton to interact with the Imgur API.
/// {@endtemplate}
class ImgurClient {
  /// {@macro imgur_client}
  factory ImgurClient() => _instance;

  ImgurClient._internal();

  static final ImgurClient _instance = ImgurClient._internal();

  /// The method used to upload an image to Imgur.
  FutureOr<ImgurUploadResponse?> uploadImage(
    List<int> content,
    String clientId,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.https(
        'api.imgur.com',
        '/3/upload',
      ),
    );
    final file = http.MultipartFile.fromBytes(
      'image',
      content,
    );

    final headers = {'Authorization': 'Client-ID $clientId'};
    request.files.add(file);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 && response.statusCode > 300) return null;

    return imgurUploadResponseFromMap(response.body);
  }
}
