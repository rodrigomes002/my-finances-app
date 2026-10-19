import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dashboard_view.dart';
import '../viewmodels/dashboard_view_model.dart';
import '../viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.dashboardViewModel});

  final DashboardViewModel? dashboardViewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final HomeViewModel _viewModel = HomeViewModel();
  late final DashboardViewModel _dashboardViewModel;
  int _selectedIndex = 0;

  static const List<String> _destinations = <String>['Dashboard', 'Upload'];

  @override
  void initState() {
    super.initState();
    _dashboardViewModel =
        widget.dashboardViewModel ?? DashboardViewModel();
    unawaited(_dashboardViewModel.load());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _dashboardViewModel.dispose();
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
      appBar: AppBar(
        title: Text(
          _selectedIndex == 1 ? 'Upload de documentos' : 'Dashboard',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person_outline_rounded,
                size: 19,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFF5F7F6)),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'My Finances',
                        style: TextStyle(
                          color: Color(0xFF182522),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (int index = 0; index < _destinations.length; index++)
                ListTile(
                  leading: Icon(
                    index == 0 ? Icons.dashboard_outlined : Icons.upload_file,
                  ),
                  title: Text(_destinations[index]),
                  selected: _selectedIndex == index,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  selectedTileColor: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (index == 0) {
                      unawaited(_dashboardViewModel.load());
                    }
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? DashboardView(viewModel: _dashboardViewModel)
          : _buildUploadView(context),
    );
  }

  Widget _buildUploadView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Form(
            key: _formKey,
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (BuildContext context, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Importe seus documentos',
                      style: TextStyle(
                        color: Color(0xFF182522),
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Envie um extrato em PDF para organizar suas finanças.',
                      style: TextStyle(color: Color(0xFF7C8985), fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Row(
                              children: <Widget>[
                                Icon(
                                  Icons.picture_as_pdf_outlined,
                                  color: Color(0xFF178A70),
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Arquivo do extrato',
                                  style: TextStyle(
                                    color: Color(0xFF27332F),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FormField<PlatformFile>(
                              initialValue: _viewModel.selectedPdf,
                              validator: (PlatformFile? value) {
                                if (value == null) {
                                  return 'Selecione um arquivo PDF para continuar';
                                }
                                return null;
                              },
                              builder: (FormFieldState<PlatformFile> field) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => _selectPdf(field),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'PDF file',
                                      errorText: field.errorText,
                                      prefixIcon: const Icon(
                                        Icons.attach_file_rounded,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      _viewModel.selectedPdf?.name ??
                                          'Selecionar arquivo PDF',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Formato aceito: PDF',
                              style: TextStyle(
                                color: Color(0xFF8C9894),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton.icon(
                                onPressed: _viewModel.isUploading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _viewModel.uploadSelectedPdf();
                                        }
                                      },
                                icon: _viewModel.isUploading
                                    ? const SizedBox(
                                        height: 17,
                                        width: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.cloud_upload_outlined),
                                label: Text(
                                  _viewModel.isUploading
                                      ? 'Enviando...'
                                      : 'Enviar documento',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_viewModel.uploadError case final String error)
                      _UploadStatus(
                        message: error,
                        icon: Icons.error_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    if (_viewModel.uploadSucceeded)
                      const _UploadStatus(
                        message: 'Arquivo enviado com sucesso.',
                        icon: Icons.check_circle_outline_rounded,
                        color: Color(0xFF178A70),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadStatus extends StatelessWidget {
  const _UploadStatus({
    required this.message,
    required this.icon,
    required this.color,
  });

  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: color, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
