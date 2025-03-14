import 'package:flutter/material.dart';
//import '../screens/chat_screen.dart'; // Import Chat Screen

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController orgCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register(BuildContext context) {
  if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    Navigator.pushReplacementNamed(context, '/chat'); // Navigate to Chat Screen
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill in all fields")),
    );
  }
}

}
