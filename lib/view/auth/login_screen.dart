import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/controller/auth_controller.dart';
import 'package:stock_search/core/constants.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.emailRequired;
                    }
                    if (!GetUtils.isEmail(value)) {
                      return AppConstants.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.passwordRequired;
                    }
                    if (value.length < 6) {
                      return AppConstants.passwordLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      controller.login(_emailController.text, _passwordController.text);
    }
  }
}
