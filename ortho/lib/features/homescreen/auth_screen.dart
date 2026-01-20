import 'package:flutter/material.dart';
import 'dart:ui';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Visual (Abstract Ortho feel)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.5,
                    colors: [Colors.blueAccent, Colors.black],
                  ),
                ),
              ),
            ),
          ),
          
          // 2. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    isLogin ? "Welcome\nBack" : "Create\nAccount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Fields
                  _buildInputField(Icons.email_outlined, "Email Address"),
                  const SizedBox(height: 20),
                  _buildInputField(Icons.lock_outline, "Password", isPassword: true),
                  if (!isLogin) ...[
                    const SizedBox(height: 20),
                    _buildInputField(Icons.badge_outlined, "Medical License ID"),
                  ],
                  
                  const SizedBox(height: 40),
                  
                  // Primary Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () {},
                      child: Text(
                        isLogin ? "SIGN IN" : "REGISTER",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Toggle Button
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: RichText(
                        text: TextSpan(
                          text: isLogin ? "New to OrthoHub? " : "Already registered? ",
                          style: const TextStyle(color: Colors.white54),
                          children: [
                            TextSpan(
                              text: isLogin ? "Sign Up" : "Login",
                              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, {bool isPassword = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }
}