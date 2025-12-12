import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    }, onError: (e) {
      print("Error listening to assignments: $e");
    });
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

  Future<void> seedSampleData() async {
    final now = DateTime.now();
    final samples = [
      Assignment(
        id: generateId(),
        title: "Calculus Homework",
        subject: "Math",
        deadline: now.add(const Duration(days: 1)),
        description: "Chapter 5 problems 1-10",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "History Essay",
        subject: "History",
        deadline: now.add(const Duration(days: 3)),
        description: "Write about WW2 causes",
        isUrgent: false,
      ),
      Assignment(
        id: generateId(),
        title: "Physics Project",
        subject: "Science",
        deadline: now.add(const Duration(days: 7)),
        description: "Build a bridge model",
        isUrgent: false,
      ),
    ];

    for (var a in samples) {
      await addAssignment(a);
    }
  }

  Future<void> importFinalsSchedule() async {
    // Clear existing assignments first (optional, but cleaner for a fresh start)
    // For now, we just append.
    
    // Hardcoded Finals Schedule AY 2025-2026
    final finals = [
      Assignment(
        id: generateId(),
        title: "Modelling Defense",
        subject: "CS 3110",
        deadline: DateTime(2025, 12, 15, 10, 0),
        description: "Venue: CIC ### (Face-to-Face)\nDeliverables: Paper, PPT, System",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Contemp World Submission",
        subject: "EGE 311",
        deadline: DateTime(2025, 12, 19, 23, 59),
        description: "Podcast Video (YouTube) & Spotify Link.\nSubmission Window: Dec 15-19.",
        isUrgent: false,
      ),
      Assignment(
        id: generateId(),
        title: "BI Presentation",
        subject: "CSDS 313",
        deadline: DateTime(2025, 12, 16, 13, 0),
        description: "Venue: CIC ###\nMain Day: Tuesday (Dec 16).\nMonday slot available for conflicted students.",
        isUrgent: true,
      ),
      Assignment(
        id: generateId(),
        title: "Emerging Trends Pres",
        subject: "ICE 311",
        deadline: DateTime(2025, 12, 19, 8, 0), // Assumed start time
        description: "Venue: ONLINE (Link TBA)\nDeliverables: Paper, PPT",
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
        deadline: DateTime(2025, 12, 20, 8, 0), // Assumed start time
        description: "Venue: ONLINE (Link TBA)\nDeliverables: Paper, PPT, System, Video",
        isUrgent: true,
      ),
    ];

    for (var a in finals) {
      await addAssignment(a);
    }
    notifyListeners();
  }
}
