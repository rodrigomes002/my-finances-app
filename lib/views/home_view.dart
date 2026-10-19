import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _selectPdf(FormFieldState<PlatformFile> field) async {
    await _viewModel.selectPdf();
    if (mounted) {
      field.didChange(_viewModel.selectedPdf);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload file')),
      body: Form(
        key: _formKey,
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (BuildContext context, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: FormField<PlatformFile>(
                    initialValue: _viewModel.selectedPdf,
                    validator: (PlatformFile? value) {
                      if (value == null) {
                        return 'Please select a PDF file';
                      }
                      return null;
                    },
                    builder: (FormFieldState<PlatformFile> field) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'PDF file',
                          errorText: field.errorText,
                          border: const OutlineInputBorder(),
                        ),
                        child: InkWell(
                          onTap: () => _selectPdf(field),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _viewModel.selectedPdf?.name ??
                                      'Select a PDF file',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
