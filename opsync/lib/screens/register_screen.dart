// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_vm.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              Container(
                height: 100,
                width: 100,
                color: Colors.transparent, // Placeholder for logo
              ),
              SizedBox(height: size.height * 0.05),
              CustomTextField(icon: Icons.business, hintText: "Organization Code", controller: viewModel.orgCodeController),
              SizedBox(height: 16),
              CustomTextField(icon: Icons.email, hintText: "Email", controller: viewModel.emailController),
              SizedBox(height: 16),
              CustomTextField(icon: Icons.lock, hintText: "Password", controller: viewModel.passwordController, obscureText: true),
              SizedBox(height: 16),
              CustomTextField(icon: Icons.lock, hintText: "Confirm Password", controller: viewModel.confirmPasswordController, obscureText: true),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => viewModel.register(context), // Pass context here
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Register", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Text("Already have an account? Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Text("Terms & Conditions", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
