import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../widgets/deadline_card.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/cyberpunk_background.dart';
import '../widgets/animated_logo.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  // Mock Data
  List<Map<String, dynamic>> get _mockAssignments {
    final now = DateTime.now();
    return [
      {
        'id': '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        'title': 'AI Ethics Essay',
        'subject': 'CS 302',
        'deadline': now.add(const Duration(hours: 18)), // 18h from now
        'description': 'Write 2000 words on the impact of LLMs on junior developer roles.',
        'isUrgent': true,
      },
      {
         'id': '550e8400-e29b-41d4-a716-446655440000',
         'title': 'Calculus Final Project',
         'subject': 'MATH 401',
         'deadline': now.add(const Duration(hours: 3)), // 3h from now
         'description': 'Complete the differential equations set and visualize the vector fields using Python.',
         'isUrgent': true,
      },
      {
        'id': '6ba7b811-9dad-11d1-80b4-00c04fd430c9',
        'title': 'React Native Widget',
        'subject': 'MOB 101',
        'deadline': now.add(const Duration(days: 2)), // 2 days
        'description': 'Implement the home screen widget using native modules for Android and iOS.',
        'isUrgent': false,
      },
      {
        'id': '7ba7b812-9dad-11d1-80b4-00c04fd430d0',
        'title': 'Database Architecture',
        'subject': 'SYS 200',
        'deadline': now.add(const Duration(days: 5)), 
        'description': 'Design the schema for the new e-commerce platform including foreign keys and indexes.',
        'isUrgent': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final assignments = _mockAssignments..sort((a, b) => (a['deadline'] as DateTime).compareTo(b['deadline'] as DateTime));

    // Calculate background based on theme for the whole scaffold if needed, but ThemeProvider handles scaffold bg usually
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: theme.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background Decor
            const CyberpunkBackground(),

            Column(
              children: [
                // Navbar
                _buildNavbar(context, theme),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48), // px-6 py-12
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        _buildHeader(theme, assignments.length),

                        const SizedBox(height: 48),

                        // Assignments Grid (Column for mobile)
                        ...assignments.map((a) => DeadlineCard(
                          id: a['id'] as String,
                          title: a['title'] as String,
                          subject: a['subject'] as String,
                          deadline: a['deadline'] as DateTime,
                          description: a['description'] as String,
                          isUrgent: a['isUrgent'] as bool,
                        )).toList(),
                        
                        const SizedBox(height: 80), // Padding for FAB space if needed or bottom scroll
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context, ThemeProvider theme) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.navbarColor, 
        border: Border(bottom: BorderSide(color: theme.navbarBorderColor, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Row(
              children: [
                AnimatedLogo(theme: theme),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                           fontSize: 18, 
                           fontWeight: FontWeight.bold,
                           fontFamily: 'Inter', // Default flutter font or ensure imported
                           color: theme.textColor,
                           height: 1.0,
                        ),
                        children: [
                          const TextSpan(text: "JohnRenan"),
                          TextSpan(
                            text: "List", 
                            style: TextStyle(
                               color: theme.currentTheme == AppTheme.light ? Colors.grey[400] : theme.accentColor
                            )
                          ),
                        ]
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "VIBECODE ED.",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w500,
                        color: theme.secondaryTextColor.withOpacity(0.6),
                      ),
                    )
                  ],
                )
              ],
            ),

            // Right Actions
            Row(
              children: [
                const ThemeSwitcher(),
                const SizedBox(width: 24),
                // Mobile Menu Button (acts as admin link)
                IconButton(
                  onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminScreen()),
                      );
                  }, 
                  icon: Icon(Icons.menu, color: theme.textColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeProvider theme, int count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
               "ACTIVE TASKS",
               style: TextStyle(
                 fontSize: 36, // 4xl
                 fontWeight: FontWeight.w900,
                 letterSpacing: -1,
                 color: theme.textColor,
               ),
             ),
             const SizedBox(height: 12),
             RichText(
               text: TextSpan(
                 style: TextStyle(
                   fontSize: 14,
                   color: theme.secondaryTextColor,
                 ),
                 children: [
                   const TextSpan(text: "Current number of assignments: "),
                   TextSpan(
                     text: "$count",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: theme.textColor,
                     )
                   )
                 ]
               ),
             )
          ],
        ),

        // Server Time (Hidden on small screens in prototype, but we can show it here if space permits)
        if (MediaQuery.of(context).size.width > 600)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Text(
               "SERVER TIME",
               style: TextStyle(
                 fontSize: 12,
                 fontWeight: FontWeight.bold,
                 letterSpacing: 2.0,
                 color: theme.currentTheme == AppTheme.cyberpunk ? theme.accentColor : theme.secondaryTextColor.withOpacity(0.5),
               ),
             ),
             const SizedBox(height: 4),
             Text(
               DateFormat('HH:mm').format(_now),
               style: TextStyle(
                 fontFamily: 'Fira Code',
                 fontSize: 20,
                 color: theme.secondaryTextColor.withOpacity(0.8),
               ),
             )
          ],
        )
      ],
    );
  }
}
