import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../repositories/pdf_repository.dart';
import '../services/file_upload_service.dart';
import '../services/pdf_picker_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({PdfRepository? repository, http.Client? httpClient})
    : _repository =
          repository ??
          PdfRepository(
            pickerService: const PdfPickerService(),
            uploadService: FileUploadService(client: httpClient),
          );

  final PdfRepository _repository;
  PlatformFile? _selectedPdf;
  bool _isUploading = false;
  String? _uploadError;
  bool _uploadSucceeded = false;

  PlatformFile? get selectedPdf => _selectedPdf;
  bool get isUploading => _isUploading;
  String? get uploadError => _uploadError;
  bool get uploadSucceeded => _uploadSucceeded;

  Future<void> selectPdf() async {
    final PlatformFile? pdf = await _repository.pickPdf();
    if (pdf == null) {
      return;
    }

    _selectedPdf = pdf;
    _uploadError = null;
    _uploadSucceeded = false;
    notifyListeners();
  }

  Future<void> uploadSelectedPdf() async {
    final PlatformFile? pdf = _selectedPdf;
    if (pdf == null || _isUploading) {
      return;
    }

    _isUploading = true;
    _uploadError = null;
    _uploadSucceeded = false;
    notifyListeners();

    try {
      await _repository.uploadPdf(pdf);
      _uploadSucceeded = true;
    } on FileUploadException catch (error) {
      _uploadError = error.message;
    } on http.ClientException {
      _uploadError =
          'Não foi possível conectar ao servidor. Verifique se a API está disponível.';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
