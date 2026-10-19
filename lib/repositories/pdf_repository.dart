import 'package:file_picker/file_picker.dart';

import '../services/file_upload_service.dart';
import '../services/pdf_picker_service.dart';

class PdfRepository {
  const PdfRepository({
    required this.pickerService,
    required this.uploadService,
  });

  final PdfPickerService pickerService;
  final FileUploadService uploadService;

  Future<PlatformFile?> pickPdf() => pickerService.pickPdf();

  Future<void> uploadPdf(PlatformFile pdf) async {
    final List<int>? bytes = pdf.bytes;
    if (bytes == null) {
      throw const FileUploadException(
        'Não foi possível ler o conteúdo do arquivo selecionado.',
      );
    }

    await uploadService.uploadPdf(bytes: bytes, fileName: pdf.name);
  }

  void dispose() => uploadService.dispose();
}
