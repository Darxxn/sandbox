// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';

// class LoginViewModel extends ChangeNotifier {
//   final TextEditingController orgCodeController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<void> login(BuildContext context) async {
//     if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
//       _isLoading = true;
//       notifyListeners();

//       final result = await AuthService.login(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       _isLoading = false;
//       notifyListeners();

//       if (result.success) {
//         Navigator.pushReplacementNamed(context, '/chat');
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(result.errorMessage)));
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
//     }
//   }

//   @override
//   void dispose() {
//     orgCodeController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }
