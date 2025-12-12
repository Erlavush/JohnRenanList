import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/assignments_provider.dart';
import '../widgets/add_assignment_dialog.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final assignmentsProvider = Provider.of<AssignmentsProvider>(context);
    final assignments = assignmentsProvider.assignments;

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
            icon: Icon(Icons.arrow_back, color: theme.navbarIconColor),
          ),
          title: Text(
            "Admin Panel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.navbarTextColor,
              fontFamily: 'Fira Code',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                assignmentsProvider.seedSampleData().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sample data added! Check Firestore.", style: TextStyle(color: theme.textColor)),
                      backgroundColor: theme.cardColor,
                    ),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text("Error: Create DB first! ($e)", style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              icon: Icon(Icons.cloud_upload_rounded, color: theme.navbarIconColor),
              tooltip: "Seed Sample Data",
            ),
            IconButton(
              onPressed: () {
                 assignmentsProvider.importFinalsSchedule().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Finals Schedule Imported! 📅", style: TextStyle(color: theme.textColor)),
                      backgroundColor: theme.cardColor,
                    ),
                  );
                 }).catchError((e) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                 });
              },
              icon: const Icon(Icons.event_note, color: Colors.amber),
              tooltip: "Import Finals Schedule",
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            // Header Stats
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 60,
                    color: theme.accentColor,
                  ),
                  const SizedBox(height: 16),
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
                    "${assignments.length} Active Tasks",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Task List
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: assignments.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = assignments[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.navbarBorderColor),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              color: theme.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Due: ${DateFormat('MMM d, HH:mm').format(task.deadline)}",
                            style: TextStyle(color: theme.secondaryTextColor),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor.withOpacity(0.1),
                            child: Text(
                              task.subject.substring(0, 1).toUpperCase(),
                              style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              assignmentsProvider.deleteAssignment(task.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Task deleted", style: TextStyle(color: theme.textColor)),
                                  backgroundColor: theme.cardColor,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => const AddAssignmentDialog(),
            );
          },
          backgroundColor: theme.fabColor,
          foregroundColor: theme.fabContentColor, 
          tooltip: 'Add Assignment',
          child: const Icon(Icons.add_rounded, size: 36),
        ),
      ),
    );
  }
}
