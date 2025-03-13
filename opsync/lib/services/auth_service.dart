import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Login function using Supabase authentication
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // If sign-in is successful, `response.session` should not be null
      if (response.session != null) {
        return AuthResult(success: true);
      } else {
        // If there's no session, treat it as a failure
        return AuthResult(
          success: false,
          errorMessage: 'Login failed. No session returned.',
        );
      }
    } on AuthException catch (e) {
      // AuthException is thrown if Supabase encounters an auth-related error
      return AuthResult(success: false, errorMessage: e.message);
    } catch (error) {
      // Catch any other unexpected errors
      return AuthResult(success: false, errorMessage: error.toString());
    }
  }

  // Registration function using Supabase authentication
  static Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    try {
      // Sign up with Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // If sign-up is successful, `response.user` should not be null
      if (response.user != null) {
        return AuthResult(success: true);
      } else {
        // If there's no user, treat it as a failure
        return AuthResult(
          success: false,
          errorMessage: 'Registration failed. No user returned.',
        );
      }
    } on AuthException catch (e) {
      // AuthException is thrown if Supabase encounters an auth-related error
      return AuthResult(success: false, errorMessage: e.message);
    } catch (error) {
      // Catch any other unexpected errors
      return AuthResult(success: false, errorMessage: error.toString());
    }
  }
}

// A simple response class for authentication functions.
class AuthResult {
  final bool success;
  final String errorMessage;

  AuthResult({required this.success, this.errorMessage = ''});
}
