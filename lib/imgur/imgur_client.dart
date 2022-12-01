import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weappear_backend/src/utils/constants.dart';

part 'imgur_upload_response.dart';

class ImgurClient {
  factory ImgurClient() => _instance;

  ImgurClient._internal();

  static final ImgurClient _instance = ImgurClient._internal();

  FutureOr<ImgurUploadResponse?> uploadImage(List<int> content) async {
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
    final clientId = Constants.imgurClientId;
    final headers = {'Authorization': 'Client-ID $clientId'};
    request.files.add(file);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 && response.statusCode > 300) return null;

    return imgurUploadResponseFromMap(response.body);
  }
}
