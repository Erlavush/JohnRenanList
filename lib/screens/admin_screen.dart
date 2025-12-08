import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: theme.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: theme.navbarColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: theme.textColor),
          ),
          title: Text(
            "Admin Panel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                size: 80,
                color: theme.accentColor,
              ),
              const SizedBox(height: 24),
              Text(
                "Secretary Mode",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Manage assignments and deadlines",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            // TODO: Add new task dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Add Task Feature Coming Soon!',
                  style: TextStyle(color: theme.textColor),
                ),
                backgroundColor: theme.cardBackgroundColor,
              ),
            );
          },
          backgroundColor: theme.accentColor,
          tooltip: 'NEW_TASK',
          child: const Icon(
            Icons.add_rounded,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
