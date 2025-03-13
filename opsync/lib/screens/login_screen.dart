import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _orgCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

void _login() {
  setState(() {
    _isLoading = true;
  });

  // Simulate a delay for demonstration
  Future.delayed(const Duration(seconds: 2), () {
    setState(() {
      _isLoading = false;
    });

    // Navigate to Chat Screen after successful login
    Navigator.pushReplacementNamed(context, '/chat');
  });
}


  @override
  void dispose() {
    _orgCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove default AppBar and use a full-screen gradient background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6BB9F0), // Lighter blue
              Color(0xFF4886E2), // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo at the top
                Image.asset(
                  'assets/images/Q.png',
                  height: 170, // Adjust as needed
                ),
                const SizedBox(height: 80),

                // Organization Code
                _buildTextField(
                  controller: _orgCodeController,
                  hintText: "Organization Code",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/org_code.svg',
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                _buildTextField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 10.0,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/email.svg',
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),

                // Password
                _buildTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/password_lock.svg',
                    ),
                  ),
                  // obscureText: true,
                ),
                const SizedBox(height: 90),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),

                // Register Link
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register'); // Navigate to Login Screen
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ", // Default size
                      style: TextStyle(
                        color: Color(0xFFCFE5FE),
                        fontSize: 16, // Keep default font size
                      ),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            fontSize: 16, // Smaller font size for "Register"
                            fontWeight: FontWeight.bold, // Optional: Make it stand out
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 8),

                // Terms & Conditions
                GestureDetector(
                  onTap: () {
                    // Show terms & conditions
                  },
                  child: const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      color: Color(0xFFCFE5FE),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Widget? prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0x33FFFFFF),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
