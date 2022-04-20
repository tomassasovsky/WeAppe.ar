import 'package:alfred/alfred.dart';
import 'package:backend/src/imgur/imgur_upload_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImgurClient {
  const ImgurClient(this.clientId);
  final String clientId;

  Future<ImgurUploadResponse?> uploadImage(HttpBodyFileUpload image) async {
    final content = image.content as List<int>;

    final file = http.MultipartFile.fromBytes(
      'image',
      content,
      contentType: MediaType.parse(image.contentType?.mimeType ?? 'image/jpeg'),
      filename: image.filename,
    );

    final headers = {'Authorization': 'Client-ID $clientId'};
    final request = http.MultipartRequest(
      'POST',
      Uri.https(
        'api.imgur.com',
        '/3/upload',
      ),
    );
    request.files.add(file);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode < 200 && response.statusCode > 300) return null;

    return imgurUploadResponseFromMap(response.body);
  }
}
