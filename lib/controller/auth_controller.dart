import 'package:get/get.dart';
import 'package:stock_search/model/user_model.dart';
import 'package:stock_search/service/auth_service.dart';
import '../core/storage_helper.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs; // Observable variable

  void toggleLogin() {
    isLoggedIn.value = !isLoggedIn.value; // Update observable
  }

  final AuthService _authService;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final user = Rxn<UserModel>();

  AuthController(this._authService);

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.login(email, password);
      final userData = UserModel.fromJson(response.data);

      if (userData.token != null) {
        await StorageHelper.saveToken(userData.token!);
        user.value = userData;
        Get.offAllNamed('/stocks');
      } else {
        throw 'Token not found in response';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    StorageHelper.clearToken();
    user.value = null;
    Get.offAllNamed('/login');
  }
}
