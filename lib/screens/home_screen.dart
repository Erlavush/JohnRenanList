import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/assignments_provider.dart'; // Import Provider
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    // consume assignments from provider
    final assignmentsProvider = Provider.of<AssignmentsProvider>(context);
    final assignments = assignmentsProvider.assignments;

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
                        if (assignments.isEmpty)
                          Center(
                            child: Text(
                              "NO ACTIVE TASKS",
                              style: TextStyle(
                                color: theme.secondaryTextColor,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          )
                        else
                          ...assignments.map((a) => DeadlineCard(
                            id: a.id,
                            title: a.title,
                            subject: a.subject,
                            deadline: a.deadline,
                            description: a.description,
                            // Recalculate urgency dynamically if needed, or trust the model
                            // Ideally urgency is derived from deadline, but let's pass a safe value
                            isUrgent: a.deadline.difference(DateTime.now()).inHours < 24 && !a.deadline.difference(DateTime.now()).isNegative, 
                          )).toList(),
                        
                        const SizedBox(height: 80),
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.navbarColor, 
        border: Border(bottom: BorderSide(color: theme.navbarBorderColor, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(top: 8),
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
                             fontFamily: 'Inter',
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
