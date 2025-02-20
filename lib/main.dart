import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/bindings/initial_bindings.dart';
import 'package:stock_search/core/authentication_wrapper.dart';
import 'package:stock_search/core/storage_helper.dart';
import 'package:stock_search/view/auth/login_screen.dart';
import 'package:stock_search/view/stock/stock_detail_screen.dart';
import 'package:stock_search/view/stock/stock_search_screen.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Market App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
      initialBinding: InitialBinding(),
      home:  AuthenticationWrapper(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginView(),
        ),
        GetPage(
          name: '/stocks',
          page: () => const StockSearchView(),
        ),
        GetPage(
          name: '/stock-details',
          page: () => const StockDetailView(),
        ),
      ],
    );
  }
}

