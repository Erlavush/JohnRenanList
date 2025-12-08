import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/assignment_model.dart';
import '../providers/assignments_provider.dart';
import '../providers/theme_provider.dart';
import 'package:uuid/uuid.dart';

class AddAssignmentDialog extends StatefulWidget {
  const AddAssignmentDialog({super.key});

  @override
  State<AddAssignmentDialog> createState() => _AddAssignmentDialogState();
}

class _AddAssignmentDialogState extends State<AddAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);
  bool _isUrgent = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, ThemeProvider theme) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: theme.accentColor,
              onPrimary: Colors.black,
              surface: theme.cardColor,
              onSurface: theme.textColor,
            ),
            dialogBackgroundColor: theme.backgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(BuildContext context, ThemeProvider theme) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: theme.accentColor,
              onPrimary: Colors.black,
              surface: theme.cardColor,
              onSurface: theme.textColor,
            ),
             timePickerTheme: TimePickerThemeData(
               backgroundColor: theme.backgroundColor,
               hourMinuteTextColor: theme.textColor,
               dayPeriodTextColor: theme.textColor,
               dialHandColor: theme.accentColor,
               dialBackgroundColor: theme.cardColor,
             )
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final deadline = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newAssignment = Assignment(
        id: const Uuid().v4(),
        title: _titleController.text,
        subject: _subjectController.text,
        description: _descriptionController.text,
        deadline: deadline,
        isUrgent: _isUrgent,
      );

      Provider.of<AssignmentsProvider>(context, listen: false).addAssignment(newAssignment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    
    // Determine Dialog Style based on theme
    Color getBg() => theme.cardColor;
    Color getText() => theme.textColor;
    Color getAccent() => theme.accentColor;

    return Dialog(
      backgroundColor: getBg(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEW ASSIGNMENT",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fira Code',
                    color: getText(),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                _buildTextField(
                  controller: _titleController,
                  label: "Task Title",
                  theme: theme,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                
                // Subject
                _buildTextField(
                  controller: _subjectController,
                  label: "Subject Code (e.g. CS101)",
                  theme: theme,
                   validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                
                // Description
                _buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  theme: theme,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                
                // Date & Time Row
                Row(
                  children: [
                    Expanded(
                      child: _buildPickerButton(
                        context: context,
                        label: DateFormat('MMM d, y').format(_selectedDate),
                        icon: Icons.calendar_today,
                        onTap: () => _pickDate(context, theme),
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPickerButton(
                        context: context,
                        label: _selectedTime.format(context),
                        icon: Icons.access_time,
                        onTap: () => _pickTime(context, theme),
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Urgent Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mark as Urgent?",
                      style: TextStyle(color: getText()),
                    ),
                    Switch(
                      value: _isUrgent,
                      onChanged: (val) => setState(() => _isUrgent = val),
                      activeColor: getAccent(),
                      activeTrackColor: getAccent().withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("CANCEL", style: TextStyle(color: theme.secondaryTextColor)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getAccent(),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("CREATE TASK", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeProvider theme,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: theme.textColor),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.secondaryTextColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.secondaryTextColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.accentColor),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: theme.backgroundColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildPickerButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required ThemeProvider theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.secondaryTextColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
          color: theme.backgroundColor.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.accentColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: theme.textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
