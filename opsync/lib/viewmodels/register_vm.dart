// lib/viewmodels/register_viewmodel.dart
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController orgCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() {
    // Implement validation and registration logic
    print("Registering with: ${emailController.text}, ${passwordController.text}");
  }
}
