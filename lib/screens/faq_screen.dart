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
        leading: BackButton(color: theme.navbarIconColor),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildFaqItem(context, theme, "WHO IS JOHN RENAN LABAY?", "john renan labay is the GOAT of the BSCS 3 class"),
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
