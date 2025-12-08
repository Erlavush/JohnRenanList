import 'package:flutter/material.dart';

enum AppTheme { cyberpunk, light, maroon }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.maroon; // Default to Maroon as requested

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  // --- Backgrounds ---
  Color get backgroundColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.black;
      case AppTheme.light:
        return const Color(0xFFF9FAFB); // bg-gray-50
      case AppTheme.maroon:
        return const Color(0xFF6C1606); // bg-deep-red
    }
  }

  // --- Typography ---
  Color get textColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white;
      case AppTheme.light:
        return const Color(0xFF111827); // text-gray-900
      case AppTheme.maroon:
        return Colors.white;
    }
  }

  Color get secondaryTextColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white70;
      case AppTheme.light:
        return const Color(0xFF6B7280); // text-gray-400 equivalent
      case AppTheme.maroon:
        return Colors.white.withOpacity(0.8);
    }
  }

  // --- Accents & Special ---
  Color get accentColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFFFAF807); // neon-yellow
      case AppTheme.light:
        return const Color(0xFF111827); // Black accent
      case AppTheme.maroon:
        return Colors.white; // White accent
    }
  }

  Color get panicColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFFFAF807); // neon-yellow
      case AppTheme.light:
        return const Color(0xFFEF4444); // red-500
      case AppTheme.maroon:
         return const Color(0xFFDC2626); // red-600
    }
  }

  // --- Navigation ---
  Color get navbarColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.black.withOpacity(0.7);
      case AppTheme.light:
        return Colors.white.withOpacity(0.7);
      case AppTheme.maroon:
        return const Color(0xFF6C1606).withOpacity(0.8);
    }
  }

  Color get navbarBorderColor {
     switch (_currentTheme) {
      case AppTheme.cyberpunk:
      case AppTheme.maroon:
        return Colors.white.withOpacity(0.1);
      case AppTheme.light:
        return const Color(0xFFE5E7EB); // gray-200
    }
  }

  // --- FAB / Actions ---
  Color get fabColor {
    switch (_currentTheme) {
       case AppTheme.cyberpunk:
        return const Color(0xFFFAF807); // neon-yellow
      case AppTheme.light:
        return Colors.black; 
      case AppTheme.maroon:
        return Colors.white;
    }
  }
  
  Color get fabContentColor {
    switch (_currentTheme) {
       case AppTheme.cyberpunk:
        return Colors.black;
      case AppTheme.light:
        return Colors.white; 
      case AppTheme.maroon:
        return const Color(0xFF6C1606); // deep-red
    }
  }

  // --- Deadline Card Styles ---
  
  // Container Logic
  Color get cardBackgroundColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return const Color(0xFF090909);
      case AppTheme.light:
      case AppTheme.maroon:
        return Colors.white;
    }
  }

  BoxBorder? getCardBorder({required bool isPanicMode}) {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        if (isPanicMode) {
           return Border.all(color: const Color(0xFFFAF807), width: 1);
        }
        return Border.all(color: const Color(0xFF222222), width: 1);
      case AppTheme.light:
         if (isPanicMode) {
             return const Border(left: BorderSide(color: Color(0xFFEF4444), width: 4)); // border-l-red-500
         }
         return Border.all(color: const Color(0xFFF3F4F6), width: 1); // border-gray-100
      case AppTheme.maroon:
          if (isPanicMode) {
             return const Border(left: BorderSide(color: Color(0xFFFAF807), width: 4)); // border-l-neon-yellow
          }
          return Border.all(color: const Color(0xFF6C1606).withOpacity(0.1)); // deep-red/10
    }
  }

  List<BoxShadow> getCardShadow({required bool isPanicMode}) {
     switch (_currentTheme) {
      case AppTheme.cyberpunk:
        if (isPanicMode) {
          return [
            BoxShadow(
              color: const Color(0xFFFAF807).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
            )
          ];
        }
        return [
           BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4)
           )
        ];
      case AppTheme.light:
         if (isPanicMode) {
            return [
               BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.1), // Ring effect approx
                  spreadRadius: 2,
               )
            ];
         }
         return [
            BoxShadow(
               color: Colors.black.withOpacity(0.05),
               blurRadius: 2,
               offset: const Offset(0, 1)
            )
         ];
      case AppTheme.maroon:
         if (isPanicMode) {
            return [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
               )
            ];
         }
         return [
            BoxShadow(
               color: Colors.black.withOpacity(0.1),
               blurRadius: 10,
               offset: const Offset(0, 4)
            )
         ];
    }
  }
  Color get cardTextColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white;
      case AppTheme.light:
        return const Color(0xFF111827); // Gray-900
      case AppTheme.maroon:
        return const Color(0xFF6C1606); // Deep Red
    }
  }

  Color get cardSecondaryTextColor {
    switch (_currentTheme) {
      case AppTheme.cyberpunk:
        return Colors.white70;
      case AppTheme.light:
        return const Color(0xFF6B7280); // text-gray-400
      case AppTheme.maroon:
        return const Color(0xFF6C1606).withOpacity(0.6); // Deep Red opacity
    }
  }
}

