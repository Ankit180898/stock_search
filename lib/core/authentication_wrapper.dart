import 'package:flutter/material.dart';
import 'package:stock_search/core/storage_helper.dart';
import 'package:stock_search/view/auth/login_screen.dart';
import 'package:stock_search/view/stock/stock_search_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  Future<bool> isLoggedIn() async {
    final token = StorageHelper.isLoggedIn();
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // navigate to stock search screen
        if (snapshot.hasData && snapshot.data == true) {
          return const StockSearchView();
        } else {
          return LoginView();
        }
      },
    );
  }
}
