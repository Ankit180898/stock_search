import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/controller/auth_controller.dart';
import 'package:stock_search/core/constants.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/app_icon.png',
                        height: 120,
                        width: 120,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                      
                  // Email Field
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
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
                      
                  // Password Field
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            controller.toggleVisibility();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                      obscureText: !controller.isVisible.value,
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
                  ),
                  const SizedBox(height: 30),
                      
                  // Login Button
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      controller.login(
        controller.emailController.text,
        controller.passwordController.text,
      );
    }
  }
}
