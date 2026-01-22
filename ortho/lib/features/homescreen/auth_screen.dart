import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Auth State
  bool isLogin = true;
  bool isLoading = false;
  bool isLoggedIn = false; // Track login status
  
  // Profile Data
  String userName = "";
  String userRole = "";
  
  final Color accentColor = const Color(0xFF10B981); // Emerald

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String _selectedRole = 'COMMON';
  final List<Map<String, String>> _roles = [
    {'value': 'COMMON', 'label': 'Common People'},
    {'value': 'DOCTOR', 'label': 'Doctor'},
    {'value': 'STUDENT', 'label': 'Student'},
    {'value': 'PROFESSOR', 'label': 'Professor'},
  ];

  final String _baseUrl = "http://192.168.2.163:8000/api"; 

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // --- PERSISTENCE LOGIC ---

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    if (token != null && token.isNotEmpty) {
      setState(() {
        isLoggedIn = true;
        userName = prefs.getString('username') ?? "User";
        userRole = prefs.getString('role') ?? "Member";
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Wipe everything on logout
    setState(() {
      isLoggedIn = false;
      _usernameController.clear();
      _passwordController.clear();
    });
    _showSnackBar("Session Terminated Safely", isError: false);
  }

  // --- BACKEND LOGIC ---
  
  Future<void> _handleAuth() async {
    setState(() => isLoading = true);
    try {
      if (isLogin) {
        final response = await http.post(
          Uri.parse("$_baseUrl/login/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": _usernameController.text,
            "password": _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access', data['access']);
          await prefs.setString('role', data['role']);
          await prefs.setString('username', data['username']);
          
          setState(() {
            isLoggedIn = true;
            userName = data['username'];
            userRole = data['role'];
          });
          _showSnackBar("Access Granted: Welcome $userName", isError: false);
          if(mounted){
            Navigator.pop(context);
          }
        } else {
          _showSnackBar("Identity Verification Failed.");
        }
      } else {
        final response = await http.post(
          Uri.parse("$_baseUrl/register/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": _usernameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "role": _selectedRole,
          }),
        );

        if (response.statusCode == 201) {
          _showSnackBar("Registration Complete. Please Sign In.", isError: false);
          setState(() => isLogin = true);
        } else {
          _showSnackBar("Registration Rejected. Check Details.");
        }
      }
    } catch (e) {
      _showSnackBar("Connection Error: Check if Backend is running.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : accentColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Background Glow
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

          SafeArea(
            child: isLoggedIn ? _buildProfileView() : _buildAuthForm(),
          ),
          
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // --- LOGGED IN PROFILE VIEW ---

  Widget _buildProfileView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.05),
              child: Icon(Icons.person_rounded, color: accentColor, size: 50),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            userName.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              userRole,
              style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 60),
          _buildActionButton(
            "BACK TO DASHBOARD", 
            Colors.white.withOpacity(0.05), 
            Colors.white, 
            () => Navigator.pop(context)
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            "LOGOUT SECURELY", 
            Colors.redAccent.withOpacity(0.1), 
            Colors.redAccent, 
            _handleLogout
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bg, Color text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: text,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: text.withOpacity(0.2))
          ),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  // --- AUTHENTICATION FORM VIEW ---

  Widget _buildAuthForm() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildBackButton(),
                const SizedBox(height: 40),
                _buildHeader(),
                const SizedBox(height: 48),
                _buildInputField(Icons.person_outline_rounded, "Username", _usernameController),
                if (!isLogin) ...[
                  const SizedBox(height: 20),
                  _buildInputField(Icons.alternate_email_rounded, "Institutional Email", _emailController),
                ],
                const SizedBox(height: 20),
                _buildInputField(Icons.lock_outline_rounded, "Security Password", _passwordController, isPassword: true),
                if (!isLogin) ...[
                  const SizedBox(height: 20),
                  _buildRoleSelector(),
                ],
                const SizedBox(height: 40),
                _buildMainButton(),
                const SizedBox(height: 24),
                _buildFooterToggle(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- REUSABLE UI WIDGETS ---

  Widget _buildBackButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLogin ? "PORTAL ACCESS" : "SECURE REGISTRATION",
          style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2.5),
        ),
        const SizedBox(height: 8),
        Text(
          isLogin ? "Welcome\nBack" : "Create\nAccount",
          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1),
        ),
      ],
    );
  }

  Widget _buildInputField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
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

  Widget _buildRoleSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          dropdownColor: const Color(0xFF0F171A),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: accentColor),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role['value'],
              child: Text(role['label']!),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedRole = val!),
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
          BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: isLoading ? null : _handleAuth,
        child: Text(
          isLogin ? "INITIALIZE SESSION" : "COMPLETE REGISTRATION",
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildFooterToggle() {
    return Center(
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
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(child: CircularProgressIndicator(color: accentColor)),
    );
  }
}