import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'constants.dart';
import 'storage_helper.dart';

class ApiClient {
  late dio.Dio _dio;

  ApiClient() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: dio.ResponseType.json,
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        
        final token = StorageHelper.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
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
        errorMessage = 'Connection timeout';
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
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}