import 'package:dio/dio.dart';
import '../core/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Response> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/local', data: {
        'identifier': email,
        'password': password,
      });
      return response;
    } catch (e) {
      throw 'Authentication failed: ${e.toString()}';
    }
  }
}