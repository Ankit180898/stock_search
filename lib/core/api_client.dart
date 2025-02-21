import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'constants.dart';
import 'storage_helper.dart';

class ApiClient {
  late dio.Dio _dio;
  final Logger _logger = Logger(printer: PrettyPrinter());

  ApiClient() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: AppConstants.baseUrl,
      responseType: dio.ResponseType.json,
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('🔍 Request: ${options.method} ${options.path}');
        _logger.i('📝 Headers: ${options.headers}');
        _logger.i('📩 Data: ${options.data}');

        final token = StorageHelper.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('✅ Response (${response.statusCode}): ${response.data}');
        return handler.next(response);
      },
      onError: (dio.DioException e, handler) {
        _handleError(e);
        return handler.next(e);
      },
    ));
  }

  void _handleError(dio.DioException e) {
    String errorMessage;
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.receiveTimeout:
        errorMessage = '⏳ Connection timeout';
        break;
      case dio.DioExceptionType.badResponse:
        errorMessage = _handleResponseError(e.response?.statusCode);
        break;
      default:
        errorMessage = AppConstants.networkError;
    }

    if (e.response?.statusCode == 401) {
      StorageHelper.clearToken();
      Get.offAllNamed('/login');
    }

    _logger.e('❌ Error: $errorMessage\n${e.message}');
    
    Get.snackbar(
      'Error',
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return AppConstants.serverError;
      default:
        return AppConstants.networkError;
    }
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      _logger.i('📤 GET Request: $path');
      _logger.i('📝 Query Parameters: $queryParameters');
      
      final response = await _dio.get(path, queryParameters: queryParameters);

      _logger.i('📥 Response (${response.statusCode}): ${response.data}');
      return response;
    } catch (e) {
      _logger.e('❌ GET Request Failed: $e');
      rethrow;
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      _logger.i('📤 POST Request: $path');
      _logger.i('📩 Data: $data');

      final response = await _dio.post(path, data: data);

      _logger.i('📥 Response (${response.statusCode}): ${response.data}');
      return response;
    } catch (e) {
      _logger.e('❌ POST Request Failed: $e');
      rethrow;
    }
  }
}
