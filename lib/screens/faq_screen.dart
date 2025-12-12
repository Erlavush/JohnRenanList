import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text("FAQs", style: TextStyle(fontFamily: 'Fira Code', fontWeight: FontWeight.bold)),
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
              _buildFaqItem(context, theme, "How do I add a task?", "Only the Class Secretary (Admin) can add tasks. If you are the secretary, use the Admin Panel."),
              _buildFaqItem(context, theme, "Why can't I edit tasks?", "To prevent accidental deletions, tasks are read-only for students."),
              _buildFaqItem(context, theme, "What is the secret code?", "The secret code is provided by your class representative to ensure privacy."),
               _buildFaqItem(context, theme, "Is this valid for excused absurdity?", "No, please do your homework."),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, ThemeProvider theme, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: theme.getCardShadow(isPanicMode: false),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              color: theme.cardTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconColor: theme.accentColor,
          collapsedIconColor: theme.cardSecondaryTextColor,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: theme.cardSecondaryTextColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
