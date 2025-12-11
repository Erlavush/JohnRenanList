import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _cycleTheme(themeProvider);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getBgColor(themeProvider.currentTheme),
            border: _getBorder(themeProvider.currentTheme),
            boxShadow: _getShadow(themeProvider.currentTheme),
          ),
          child: Icon(
            _getIcon(themeProvider.currentTheme),
            size: 20,
            color: _getIconColor(themeProvider.currentTheme),
          ),
        ),
      ),
    );
  }

  void _cycleTheme(ThemeProvider provider) {
    switch (provider.currentTheme) {
      case AppTheme.cyberpunk:
        provider.setTheme(AppTheme.light);
        break;
      case AppTheme.light:
        provider.setTheme(AppTheme.maroon);
        break;
      case AppTheme.maroon:
        provider.setTheme(AppTheme.cyberpunk);
        break;
    }
  }

  IconData _getIcon(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return Icons.wb_sunny_outlined;
      case AppTheme.maroon:
        return Icons.water_drop_outlined;
      case AppTheme.cyberpunk:
      default:
        return Icons.nightlight_round;
    }
  }

  Color _getBgColor(AppTheme theme) {
    // Hover logic from React
    if (_isHovered) {
       switch (theme) {
        case AppTheme.light:
          return Colors.grey[100]!; // hover:bg-gray-100
        case AppTheme.maroon:
          return const Color(0xFF5A1205); // hover:bg-[#5a1205]
        case AppTheme.cyberpunk:
          return Colors.black; // hover:bg-black
      }
    }
    // Normal state
    switch (theme) {
      case AppTheme.light:
        return Colors.white;
      case AppTheme.maroon:
        return Colors.transparent; // Transparent on White Navbar
      case AppTheme.cyberpunk:
      default:
        return const Color(0xFF1A1A1A);
    }
  }

  Color _getIconColor(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return Colors.orange;
      case AppTheme.maroon:
        return const Color(0xFF6C1606); // Deep Red Icon
      case AppTheme.cyberpunk:
      default:
        return const Color(0xFFFAF807); // Neon Yellow
    }
  }

  BoxBorder? _getBorder(AppTheme theme) {
     // React: border-neon-yellow/30 hover:border-neon-yellow/60
    if (theme == AppTheme.cyberpunk && _isHovered) {
       return Border.all(color: const Color(0xFFFAF807).withOpacity(0.6));
    }

    switch (theme) {
      case AppTheme.light:
        return null; // React has no border for light? "shadow-gray-200"
      case AppTheme.maroon:
        return Border.all(color: const Color(0xFF6C1606).withOpacity(0.2));
      case AppTheme.cyberpunk:
      default:
        return Border.all(color: const Color(0xFFFAF807).withOpacity(0.3));
    }
  }

  List<BoxShadow> _getShadow(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ]; 
      case AppTheme.maroon:
        return [
           BoxShadow(
            color: const Color(0xFF6C1606).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ];
      case AppTheme.cyberpunk:
      default:
        return [
          BoxShadow(
            color: const Color(0xFFFAF807).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ];
    }
  }
}
