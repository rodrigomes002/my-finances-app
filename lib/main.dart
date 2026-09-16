import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Upload file')),
        body: const MyHomePage(title: 'My Finances'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageFormState();
}

class _MyHomePageFormState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? _selectedPdf;

  Future<void> _selectPdf() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedPdf = result.files.single;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Padding(
            padding: const .symmetric(vertical: 16.0),
            child: FormField<PlatformFile>(
              initialValue: _selectedPdf,
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
                    onTap: () async {
                      await _selectPdf();
                      field.didChange(_selectedPdf);
                    },
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.attach_file),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedPdf?.name ?? 'Select a PDF file',
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
            padding: const .symmetric(vertical: 1.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
