import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/theme_switcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontFamily: 'Fira Code', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.navbarColor,
        leading: BackButton(color: theme.textColor),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildSectionHeader(theme, "Appearance"),
              const SizedBox(height: 16),
              _buildSettingsTile(
                theme, 
                icon: Icons.palette_outlined, 
                title: "Theme Mode", 
                trailing: const ThemeSwitcher()
              ),
              
              const SizedBox(height: 32),
              _buildSectionHeader(theme, "About"),
              const SizedBox(height: 16),
               _buildSettingsTile(
                theme, 
                icon: Icons.info_outline, 
                title: "Version", 
                subtitle: "1.0.0 (Beta)",
              ),
               _buildSettingsTile(
                theme, 
                icon: Icons.code, 
                title: "Developer", 
                subtitle: "John Renan Labay",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeProvider theme, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: theme.secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingsTile(ThemeProvider theme, {required IconData icon, required String title, String? subtitle, Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: theme.currentTheme == AppTheme.cyberpunk 
            ? Border.all(color: theme.accentColor.withOpacity(0.3))
            : null,
        boxShadow: theme.getCardShadow(isPanicMode: false),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.accentColor),
        title: Text(title, style: TextStyle(color: theme.cardTextColor, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: theme.cardSecondaryTextColor, fontSize: 12)) : null,
        trailing: trailing,
      ),
    );
  }
}
