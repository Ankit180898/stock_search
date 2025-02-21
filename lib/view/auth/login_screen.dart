import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_search/controller/auth_controller.dart';
import 'package:stock_search/core/constants.dart';
import 'package:stock_search/core/theme.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/app_icon.png', height: 100, width: 100),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: AppTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please sign in to your account',
                    style: AppTheme.bodyText2.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  _buildEmailField(),
                  const SizedBox(height: 24),

                  // Password Field
                  _buildPasswordField(),

                  const SizedBox(height: 32),

                  // Login Button
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      style: AppTheme.bodyText1,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
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
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        style: AppTheme.bodyText1,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
          suffixIcon: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                controller.isVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                key: ValueKey<bool>(controller.isVisible.value),
                color: Colors.grey.shade600,
              ),
            ),
            onPressed: controller.toggleVisibility,
          ),
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
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
            elevation: controller.isLoading.value ? 0 : 2,
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
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text('Sign In', style: AppTheme.buttonText),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      controller.login(
        controller.emailController.text.trim(),
        controller.passwordController.text,
      );
    }
  }
}
