import 'package:file_picker/file_picker.dart';

import '../services/pdf_picker_service.dart';

class PdfRepository {
  const PdfRepository({required PdfPickerService pickerService})
    : _pickerService = pickerService;

  final PdfPickerService _pickerService;

  Future<PlatformFile?> pickPdf() => _pickerService.pickPdf();
}
