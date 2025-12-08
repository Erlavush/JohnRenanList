import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

class AnimatedLogo extends StatefulWidget {
  final ThemeProvider theme;
  const AnimatedLogo({super.key, required this.theme});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    
    // Determine colors based on state
    Color getBgColor() {
      if (_isHovered && theme.currentTheme == AppTheme.cyberpunk) {
        return theme.accentColor; // Neon Yellow
      }
      switch (theme.currentTheme) {
        case AppTheme.cyberpunk: return const Color(0xFF1A1A1A);
        case AppTheme.light: return Colors.grey[100]!;
        case AppTheme.maroon: return Colors.black26;
      }
    }

    Color getIconColor() {
       if (_isHovered && theme.currentTheme == AppTheme.cyberpunk) {
        return Colors.black;
      }
      return theme.currentTheme == AppTheme.cyberpunk ? theme.accentColor : theme.textColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: getBgColor(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.terminal_rounded,
          size: 20,
          color: getIconColor(),
        ),
      ),
    );
  }
}
