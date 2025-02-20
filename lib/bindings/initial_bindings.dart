import 'package:get/get.dart';
import 'package:stock_search/controller/auth_controller.dart';
import 'package:stock_search/controller/stock_controller.dart';
import 'package:stock_search/core/api_client.dart';
import 'package:stock_search/service/auth_service.dart';
import 'package:stock_search/service/stock_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // API Client
    Get.put(ApiClient());

    // Services
    Get.put(AuthService(Get.find<ApiClient>()));
    Get.put(StockService(Get.find<ApiClient>()));

    // Controllers
    Get.put(AuthController(Get.find<AuthService>()));
    Get.put(StockController(Get.find<StockService>()));
  }
}