import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Login function using Supabase authentication with organization code validation
  static Future<AuthResult> login({
    required String email,
    required String password,
    required String organizationCode,
  }) async {
    try {
      // Check if the provided organization code exists in the organizations table
      final orgResponse = await Supabase.instance.client
          .from('organizations')
          .select()
          .eq('organization_code', organizationCode)
          .execute();

      if (orgResponse.error != null ||
          (orgResponse.data as List).isEmpty) {
        return AuthResult(success: false, errorMessage: 'Invalid organization code.');
      }

      // Proceed with sign in
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // After sign in, verify that the user's metadata organization code matches
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null && user.userMetadata != null) {
          if (user.userMetadata['organization_code'] == organizationCode) {
            return AuthResult(success: true);
          } else {
            return AuthResult(success: false, errorMessage: 'Organization code does not match your registered code.');
          }
        } else {
          return AuthResult(success: false, errorMessage: 'User data not available.');
        }
      } else {
        return AuthResult(success: false, errorMessage: 'Login failed. No session returned.');
      }
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (error) {
      return AuthResult(success: false, errorMessage: error.toString());
    }
  }

  // Registration function using Supabase authentication with organization code validation
  static Future<AuthResult> register({
    required String email,
    required String password,
    required String organizationCode,
  }) async {
    try {
      // Validate organization code by querying the organizations table
      final orgResponse = await Supabase.instance.client
          .from('organizations')
          .select()
          .eq('organization_code', organizationCode)
          .execute();

      if (orgResponse.error != null ||
          (orgResponse.data as List).isEmpty) {
        return AuthResult(success: false, errorMessage: 'Invalid organization code.');
      }

      // Proceed with sign up; store organization code in user metadata
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'organization_code': organizationCode,
        },
      );

      if (response.user != null) {
        return AuthResult(success: true);
      } else {
        return AuthResult(success: false, errorMessage: 'Registration failed. No user returned.');
      }
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (error) {
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
