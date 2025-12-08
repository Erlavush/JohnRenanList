import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CyberpunkBackground extends StatelessWidget {
  const CyberpunkBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    // Only show for Cyberpunk theme
    if (theme.currentTheme != AppTheme.cyberpunk) {
      return const SizedBox.shrink(); 
    }

    return Stack(
      children: [
        // Red Blob (Top Right)
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 500,
            height: 500,
            decoration: const BoxDecoration(
               shape: BoxShape.circle,
               boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6C1606),
                    blurRadius: 150,
                    spreadRadius: 50,
                  )
               ] 
            ),
          ),
        ),

        // Yellow Blob (Bottom Left)
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
             width: 400,
             height: 400,
             decoration: const BoxDecoration(
               shape: BoxShape.circle,
               boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFAF807), // Neon Yellow
                    blurRadius: 150,
                    spreadRadius: 20,
                  )
               ] 
            ),
             child: Opacity(
               opacity: 0.05,
               child: Container(color: Colors.transparent),
             ),
          ),
        ),
      ],
    );
  }
}
