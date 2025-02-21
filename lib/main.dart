import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/bindings/initial_bindings.dart';
import 'package:stock_search/core/authentication_wrapper.dart';
import 'package:stock_search/core/storage_helper.dart';
import 'package:stock_search/core/theme.dart';
import 'package:stock_search/view/auth/login_screen.dart';
import 'package:stock_search/view/stock/stock_detail_screen.dart';
import 'package:stock_search/view/stock/stock_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await StorageHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Search',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      home: AuthenticationWrapper(),
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/stocks', page: () => const StockSearchView()),
        GetPage(name: '/stock-details', page: () => const StockDetailView()),
      ],
    );
  }
}
