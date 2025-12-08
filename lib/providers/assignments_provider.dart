import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/assignment_model.dart';

class AssignmentsProvider extends ChangeNotifier {
  final List<Assignment> _assignments = [
    Assignment(
        id: '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        title: 'AI Ethics Essay',
        subject: 'CS 302',
        deadline: DateTime.now().add(const Duration(hours: 18)),
        description: 'Write 2000 words on the impact of LLMs on junior developer roles.',
        isUrgent: true,
      ),
      Assignment(
         id: '550e8400-e29b-41d4-a716-446655440000',
         title: 'Calculus Final Project',
         subject: 'MATH 401',
         deadline: DateTime.now().add(const Duration(hours: 3)),
         description: 'Complete the differential equations set and visualize the vector fields using Python.',
         isUrgent: true,
      ),
      Assignment(
        id: '6ba7b811-9dad-11d1-80b4-00c04fd430c9',
        title: 'React Native Widget',
        subject: 'MOB 101',
        deadline: DateTime.now().add(const Duration(days: 2)),
        description: 'Implement the home screen widget using native modules for Android and iOS.',
        isUrgent: false,
      ),
      Assignment(
        id: '7ba7b812-9dad-11d1-80b4-00c04fd430d0',
        title: 'Database Architecture',
        subject: 'SYS 200',
        deadline: DateTime.now().add(const Duration(days: 5)), 
        description: 'Design the schema for the new e-commerce platform including foreign keys and indexes.',
        isUrgent: false,
      ),
  ];

  List<Assignment> get assignments {
    // Return sorted list by deadline
    final sortedList = List<Assignment>.from(_assignments);
    sortedList.sort((a, b) => a.deadline.compareTo(b.deadline));
    return sortedList;
  }
  
  int get activeCount => _assignments.length;

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }
  
  // Factory method to create a new ID
  String generateId() {
    return const Uuid().v4();
  }
}
