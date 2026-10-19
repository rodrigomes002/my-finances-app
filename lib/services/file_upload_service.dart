import 'package:http/http.dart' as http;

class FileUploadService {
  FileUploadService({http.Client? client, Uri? endpoint})
    : _client = client ?? http.Client(),
      _endpoint =
          endpoint ?? Uri.parse('http://localhost:8080/api/files/upload');

  final http.Client _client;
  final Uri _endpoint;

  Future<void> uploadPdf({
    required List<int> bytes,
    required String fileName,
  }) async {
    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      _endpoint,
    )..files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ),
    );

    final http.StreamedResponse response = await _client.send(request);
    await response.stream.drain<void>();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw FileUploadException(
        'O servidor recusou o arquivo (HTTP ${response.statusCode}).',
      );
    }
  }

  void dispose() => _client.close();
}

class FileUploadException implements Exception {
  const FileUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}
