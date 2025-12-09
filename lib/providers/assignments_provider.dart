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
}
