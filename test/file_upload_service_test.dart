import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_finances_app/services/file_upload_service.dart';

void main() {
  test(
    'sends the PDF as multipart field "file" to the upload endpoint',
    () async {
      const List<int> fileBytes = <int>[37, 80, 68, 70, 45, 49, 46, 55];
      bool requestReceived = false;

      final FileUploadService service = FileUploadService(
        endpoint: Uri.parse('http://localhost:8080/api/files/upload'),
        client: MockClient((http.Request request) async {
          requestReceived = true;
          expect(request.method, 'POST');
          expect(request.url.path, '/api/files/upload');
          expect(
            request.headers['content-type'],
            startsWith('multipart/form-data; boundary='),
          );
          expect(
            request.body,
            contains('name="file"; filename="statement.pdf"'),
          );
          expect(request.body, contains('%PDF-1.7'));
          return http.Response('', 201);
        }),
      );

      await service.uploadPdf(bytes: fileBytes, fileName: 'statement.pdf');

      expect(requestReceived, isTrue);
      service.dispose();
    },
  );

  test('reports non-success API responses', () async {
    final FileUploadService service = FileUploadService(
      client: MockClient((http.Request request) async {
        return http.Response('', 500);
      }),
    );
    addTearDown(service.dispose);

    expect(
      () => service.uploadPdf(bytes: <int>[1], fileName: 'statement.pdf'),
      throwsA(
        isA<FileUploadException>().having(
          (FileUploadException error) => error.message,
          'message',
          contains('HTTP 500'),
        ),
      ),
    );
  });
}
