import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../viewmodels/register_vm.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);
    //final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6BB9F0), // Lighter blue (same as login)
              Color(0xFF4886E2), // Darker blue (same as login)
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
                  height: 170, // Same size as login
                ),
                const SizedBox(height: 50),

                // Organization Code
                _buildTextField(
                  controller: viewModel.orgCodeController,
                  hintText: "Organization Code",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/org_code.svg'),
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                _buildTextField(
                  controller: viewModel.emailController,
                  hintText: "Email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: SvgPicture.asset('assets/icons/email.svg'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),

                // Password
                _buildTextField(
                  controller: viewModel.passwordController,
                  hintText: "Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/password_lock.svg'),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Confirm Password
                _buildTextField(
                  controller: viewModel.confirmPasswordController,
                  hintText: "Confirm Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/password_lock.svg'),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),

                // Register Button
                ElevatedButton(
                  onPressed: () => viewModel.register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Link
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/'); // Navigate to Login Screen
                  },
                  child:  RichText(
                    text: TextSpan(
                      text: "Already have an account? ", // Default size
                      style: TextStyle(
                        color: Color(0xFFCFE5FE),
                        fontSize: 16, // Keep default font size
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            fontSize: 16, // Smaller font size for "Register"
                            fontWeight: FontWeight.bold, // Optional: Make it stand out
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // Terms & Conditions
                GestureDetector(
                  onTap: () {},
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
