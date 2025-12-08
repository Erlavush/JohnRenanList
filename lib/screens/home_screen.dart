import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/deadline_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock Data: 4 assignments with varying deadlines
  List<Map<String, dynamic>> get _mockAssignments {
    final now = DateTime.now();
    return [
      {
        'title': 'Algorithm Quiz',
        'subject': 'CS 301',
        'deadline': now.add(const Duration(hours: 3)),
        'isUrgent': true,
      },
      {
        'title': 'Calculus Final',
        'subject': 'MATH 201',
        'deadline': now.add(const Duration(hours: 18)),
        'isUrgent': true,
      },
      {
        'title': 'Physics Lab Report',
        'subject': 'PHYS 102',
        'deadline': now.add(const Duration(hours: 48)),
        'isUrgent': false,
      },
      {
        'title': 'History Research Paper',
        'subject': 'HIST 101',
        'deadline': now.add(const Duration(days: 5)),
        'isUrgent': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: theme.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context, theme),
        body: _buildBody(context, theme),
        floatingActionButton: _buildFAB(context, theme),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeProvider theme) {
    return AppBar(
      backgroundColor: theme.navbarColor,
      elevation: 0,
      title: Row(
        children: [
          Icon(
            Icons.terminal_rounded,
            color: theme.accentColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            "JohnRenanList",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        // Theme Switcher
        _ThemeSwitcherButton(
          icon: Icons.nightlight_round,
          isActive: theme.currentTheme == AppTheme.cyberpunk,
          onTap: () => theme.setTheme(AppTheme.cyberpunk),
          activeColor: theme.accentColor,
          inactiveColor: theme.secondaryTextColor,
          tooltip: 'Cyberpunk',
        ),
        _ThemeSwitcherButton(
          icon: Icons.wb_sunny_rounded,
          isActive: theme.currentTheme == AppTheme.light,
          onTap: () => theme.setTheme(AppTheme.light),
          activeColor: theme.accentColor,
          inactiveColor: theme.secondaryTextColor,
          tooltip: 'Light',
        ),
        _ThemeSwitcherButton(
          icon: Icons.water_drop_rounded,
          isActive: theme.currentTheme == AppTheme.maroon,
          onTap: () => theme.setTheme(AppTheme.maroon),
          activeColor: theme.accentColor,
          inactiveColor: theme.secondaryTextColor,
          tooltip: 'Maroon',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ThemeProvider theme) {
    // Sort by deadline
    final assignments = List<Map<String, dynamic>>.from(_mockAssignments)
      ..sort((a, b) => (a['deadline'] as DateTime).compareTo(b['deadline'] as DateTime));

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final a = assignments[index];
        return DeadlineCard(
          title: a['title'] as String,
          subject: a['subject'] as String,
          deadline: a['deadline'] as DateTime,
          isUrgent: a['isUrgent'] as bool,
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context, ThemeProvider theme) {
    return Tooltip(
      message: 'NEW_TASK',
      preferBelow: false,
      child: FloatingActionButton.large(
        onPressed: () {
          // TODO: Add new task functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Add Task Coming Soon!',
                style: TextStyle(color: theme.textColor),
              ),
              backgroundColor: theme.cardColor,
            ),
          );
        },
        backgroundColor: theme.accentColor,
        child: const Icon(
          Icons.add_rounded,
          size: 36,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ThemeSwitcherButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final String tooltip;

  const _ThemeSwitcherButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? activeColor.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
