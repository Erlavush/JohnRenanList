import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String id;
  final String title;
  final String subject;
  final DateTime deadline;
  final String description;
  final bool isUrgent;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.description,
    required this.isUrgent,
  });

  // Factory to create Assignment from Firestore DocumentSnapshot
  factory Assignment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Assignment(
      id: doc.id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      isUrgent: data['isUrgent'] ?? false,
    );
  }

  // Method to convert Assignment to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'deadline': Timestamp.fromDate(deadline),
      'description': description,
      'isUrgent': isUrgent,
    };
  }
}
