import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate a small delay for "processing" feel
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final error = await userProvider.login(_idController.text, _codeController.text);

    setState(() => _isLoading = false);

    if (error == null) {
      // Success
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    // Force Maroon theme aesthetics or use provider if we want dynamic login
    // Let's use the provider's current theme but default to Maroon-like entry if unset
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Icon
                Icon(Icons.school_rounded, size: 80, color: theme.accentColor),
                const SizedBox(height: 24),
                
                Text(
                  "Student Portal",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "JohnRenanList",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 48),

                // ID Field
                _buildLabel(theme, "Class ID (e.g. 2023-XXXXX)"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _idController,
                  style: TextStyle(color: theme.cardTextColor),
                  decoration: _buildInputDecoration(theme, Icons.badge_outlined),
                  validator: (val) => val!.isEmpty ? "Enter your ID" : null,
                ),
                const SizedBox(height: 24),

                // Secret Code Field
                _buildLabel(theme, "Secret Code"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _codeController,
                  obscureText: true,
                  style: TextStyle(color: theme.cardTextColor),
                  decoration: _buildInputDecoration(theme, Icons.lock_outline),
                  validator: (val) => val!.isEmpty ? "Enter the class code" : null,
                ),
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accentColor,
                      foregroundColor: theme.backgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: _isLoading 
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: theme.backgroundColor))
                      : const Text(
                          "Access Portal",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
                
                const SizedBox(height: 24),
                Text(
                  "Only authorized students of this class\nmay access this application.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.secondaryTextColor.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(ThemeProvider theme, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: theme.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(ThemeProvider theme, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: theme.accentColor),
      filled: true,
      fillColor: theme.cardBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.navbarBorderColor ?? Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.accentColor, width: 2),
      ),
    );
  }
}
