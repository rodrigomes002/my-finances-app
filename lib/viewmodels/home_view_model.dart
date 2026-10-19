import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../repositories/pdf_repository.dart';
import '../services/pdf_picker_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({PdfRepository? repository})
    : _repository =
          repository ??
          PdfRepository(pickerService: const PdfPickerService());

  final PdfRepository _repository;
  PlatformFile? _selectedPdf;

  PlatformFile? get selectedPdf => _selectedPdf;

  Future<void> selectPdf() async {
    final PlatformFile? pdf = await _repository.pickPdf();
    if (pdf == null) {
      return;
    }

    _selectedPdf = pdf;
    notifyListeners();
  }
}
