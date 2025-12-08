import 'package:flutter/material.dart';

enum AppTheme { cyberpunk, light, maroon }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.cyberpunk;

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  // Background Colors
  Color get backgroundColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFF000000); // Black
      case AppTheme.light:
        return const Color(0xFFF9FAFB); // Gray-50
      case AppTheme.maroon:
        return const Color(0xFF6C1606); // Deep Red
    }
  }

  // Card Colors
  Color get cardColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFF1A1A1A); // Dark Grey
      case AppTheme.light:
        return const Color(0xFFFFFFFF); // White
      case AppTheme.maroon:
        return const Color(0xFF000000); // Black
    }
  }

  // Primary Text Colors
  Color get textColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white;
      case AppTheme.light:
        return const Color(0xFF111827); // Gray-900
      case AppTheme.maroon:
        return Colors.white;
    }
  }

  // Secondary/Muted Text
  Color get secondaryTextColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white70;
      case AppTheme.light:
        return const Color(0xFF6B7280); // Gray-500
      case AppTheme.maroon:
        return Colors.white70;
    }
  }

  // Accent Color (for highlights, FAB, etc.)
  Color get accentColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFFFAF807); // Neon Yellow
      case AppTheme.light:
        return const Color(0xFF3B82F6); // Blue-500
      case AppTheme.maroon:
        return const Color(0xFFFAF807); // Neon Yellow
    }
  }

  // Urgent/Panic Color
  Color get urgentColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFF6C1606); // Deep Red
      case AppTheme.light:
        return const Color(0xFFDC2626); // Red-600
      case AppTheme.maroon:
        return const Color(0xFFFAF807); // Neon Yellow (contrast)
    }
  }

  // Panic Border Color
  Color get panicBorderColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFFFAF807); // Neon Yellow
      case AppTheme.light:
        return const Color(0xFFDC2626); // Red-600
      case AppTheme.maroon:
        return const Color(0xFFFAF807); // Neon Yellow
    }
  }

  // Navbar/AppBar Color
  Color get navbarColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFF0D0D0D); // Near Black
      case AppTheme.light:
        return Colors.white;
      case AppTheme.maroon:
        return const Color(0xFF4A0F04); // Darker Maroon
    }
  }
}
