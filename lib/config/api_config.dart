class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static Uri get lancamentosEndpoint => Uri.parse('$baseUrl/api/lancamentos');

  static Uri get fileUploadEndpoint => Uri.parse('$baseUrl/api/files/upload');
}
