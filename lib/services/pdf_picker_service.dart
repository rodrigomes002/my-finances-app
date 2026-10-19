import 'package:file_picker/file_picker.dart';

class PdfPickerService {
  const PdfPickerService();

  Future<PlatformFile?> pickPdf() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    return result.files.single;
  }
}
