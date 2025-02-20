class AppConstants {
  // API Constants
  static const String baseUrl = 'https://illuminate-production.up.railway.app/api';
  static const String authEndpoint = '/auth/local';
  static const String stockSearchEndpoint = '/stocks/search';
  static const String stockDetailsEndpoint = '/stocks/';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Error Messages
  static const String networkError = 'Network error occurred. Please try again.';
  static const String invalidCredentials = 'Invalid email or password';
  static const String serverError = 'Server error occurred';
  
  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordLength = 'Password must be at least 6 characters';
}