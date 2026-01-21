import 'package:flutter/material.dart';
import 'dart:ui';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final Color accentColor = const Color(0xFF10B981); // Emerald matching Resources

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // 1. Ambient Glow (Continuity with Knowledge Hub)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.08),
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Header Section
                        Text(
                          isLogin ? "PORTAL ACCESS" : "SECURE REGISTRATION",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLogin ? "Welcome\nBack" : "Create\nAccount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isLogin 
                            ? "Authenticate to access RUSA 2.0 AI Tools." 
                            : "Join the elite network of orthopaedic researchers.",
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15),
                        ),
                        const SizedBox(height: 48),

                        // Form Fields (Dynamic)
                        _buildInputField(Icons.alternate_email_rounded, "Institutional Email"),
                        const SizedBox(height: 20),
                        _buildInputField(Icons.lock_outline_rounded, "Security Password", isPassword: true),
                        
                        if (!isLogin) ...[
                          const SizedBox(height: 20),
                          _buildInputField(Icons.verified_user_outlined, "Medical License ID"),
                        ],

                        const SizedBox(height: 40),

                        // Action Button
                        _buildMainButton(),

                        const SizedBox(height: 24),

                        // Footer Toggle
                        Center(
                          child: TextButton(
                            onPressed: () => setState(() => isLogin = !isLogin),
                            child: RichText(
                              text: TextSpan(
                                text: isLogin ? "New to the platform? " : "Already verified? ",
                                style: const TextStyle(color: Colors.white38, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: isLogin ? "Register" : "Sign In",
                                    style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildInputField(IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          icon: Icon(icon, color: accentColor.withOpacity(0.6), size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: () {
          // Add navigation logic to main dashboard here
        },
        child: Text(
          isLogin ? "INITIALIZE SESSION" : "COMPLETE REGISTRATION",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13),
        ),
      ),
    );
  }
}