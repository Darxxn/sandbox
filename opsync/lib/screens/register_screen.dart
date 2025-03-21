import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _orgCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    // Validate that passwords match.
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final result = await AuthService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      organizationCode: _orgCodeController.text.trim(),
    );
    setState(() {
      _isLoading = false;
    });
    if (result.success) {
      // Registration successful; navigate to login screen.
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    _orgCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(0.08, -0.9),
            end: FractionalOffset(0.86, 0.77),
            colors: [Colors.white, Color.fromRGBO(94, 181, 255, 1)],
            stops: [0.28, 0.87],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Q.png',
                  height: 170,
                ),
                const SizedBox(height: 50),
                // Organization Code
                _buildTextField(
                  controller: _orgCodeController,
                  hintText: "Organization Code",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/org_code.svg'),
                  ),
                ),
                const SizedBox(height: 30),
                // Email
                _buildTextField(
                  controller: _emailController,
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
                  controller: _passwordController,
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
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/icons/password_lock.svg'),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _register,
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
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(
                      color: Color(0xFFCFE5FE),
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/');
                              },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      color: Color(0xFFCFE5FE),
                      fontSize: 14,
                      fontFamily: 'Motiraw',
                      fontWeight: FontWeight.normal,
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
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Motiraw',
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white70,
          fontFamily: 'Motiraw',
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: const Color(0x33FFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
