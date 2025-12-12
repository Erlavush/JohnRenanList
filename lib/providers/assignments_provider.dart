import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:convert';
import '../models/assignment_model.dart';

class AssignmentsProvider extends ChangeNotifier {
  List<Assignment> _assignments = [];
  final CollectionReference _collection = FirebaseFirestore.instance.collection('assignments');
  StreamSubscription? _subscription;

  List<Assignment> get assignments {
    // Return sorted list by deadline
    final sortedList = List<Assignment>.from(_assignments);
    sortedList.sort((a, b) => a.deadline.compareTo(b.deadline));
    return sortedList;
  }
  
  int get activeCount => _assignments.length;

  Future<void> init() async {
    _subscription = _collection.snapshots().listen((snapshot) {
      _assignments = snapshot.docs
          .map((doc) => Assignment.fromFirestore(doc))
          .toList();
      notifyListeners();
      _updateWidget();
    }, onError: (e) {
      print("Error listening to assignments: $e");
    });
  }

  Future<void> _updateWidget() async {
    try {
      // Use the getter 'assignments' which is already sorted
      final jsonString = jsonEncode(assignments.map((a) => a.toJson()).toList());
      await HomeWidget.saveWidgetData('full_schedule_json', jsonString);
      await HomeWidget.updateWidget(name: 'WidgetProvider');
    } catch (e) {
      print("Error updating widget: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addAssignment(Assignment assignment) async {
    // Optimistic update (optional, but let's rely on stream for single source of truth)
    try {
      await _collection.doc(assignment.id).set(assignment.toMap());
    } catch (e) {
      print("Error adding assignment: $e");
      rethrow;
    }
  }

  Future<void> deleteAssignment(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print("Error deleting assignment: $e");
      rethrow;
    }
  }
  
  // Factory method to create a new ID
  String generateId() {
    return const Uuid().v4();
  }

  Future<void> importFinalsSchedule() async {
    // Hardcoded Finals Schedule AY 2025-2026
    final finals = [
      Assignment(
        id: generateId(),
        title: "Modelling Defense",
        subject: "CS 3110",
        deadline: DateTime(2025, 12, 15, 10, 0),
        description: "Venue: CIC ### (Face-to-Face)\nDeliverables: Paper, PPT, System\nNotes: Present to Sir Hobs.",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Machine Learning Exam",
        subject: "CSDS 314",
        deadline: DateTime(2025, 12, 15, 10, 0),
        description: "Venue: Online via UVE\nNotes: Opens at 10:00 AM",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Contemp World Submission",
        subject: "EGE 311",
        deadline: DateTime(2025, 12, 19, 23, 59),
        description: "Podcast Video (YouTube) & Spotify Link.\nSubmission Window: Dec 15-19.\nMode: Online Submission",
        isUrgent: false,
      ),
      Assignment(
        id: generateId(),
        title: "BI Presentation",
        subject: "CSDS 313",
        deadline: DateTime(2025, 12, 16, 13, 0),
        description: "Venue: CIC ### (Face-to-Face)\nDeliverables: Paper, PPT, Dashboard\nNotes: Main presentation day is Tuesday.",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Emerging Trends Pres",
        subject: "ICE 311",
        deadline: DateTime(2025, 12, 19, 8, 0), // Time TBA, assuming morning start
        description: "Venue: ONLINE (Link TBA)\nDeliverables: Paper, PPT\nNotes: Present to Ma'am Ivy.",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Applied Data Science",
        subject: "CSDS 312",
        deadline: DateTime(2025, 12, 19, 23, 59),
        description: "Venue: UVE Link\nDeliverables: Video, Short Narrative",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Big Data Simulation",
        subject: "CSDS 311",
        deadline: DateTime(2025, 12, 20, 8, 0), // Time TBA, assuming morning start
        description: "Venue: ONLINE (Link TBA)\nDeliverables: Paper, PPT, System Demo, Video\nNotes: Present to Ma'am Ivy.",
        isUrgent: true,
      ),
    ];

    for (var a in finals) {
      await addAssignment(a);
    }
    notifyListeners();
  }
}
