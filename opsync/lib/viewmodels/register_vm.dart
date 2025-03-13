import 'package:flutter/material.dart';
import '../screens/chat_screen.dart'; // Import Chat Screen

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController orgCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register(BuildContext context) {
    // Add validation logic here if needed
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Navigate to Chat Screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }
}
