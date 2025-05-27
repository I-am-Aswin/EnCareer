// lib/models/enrollment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String roadmapId;
  final String title;
  final String status;
  final int progress;
  final DateTime joinedAt;
  final DateTime? completedAt;

  Enrollment({
    required this.roadmapId,
    required this.title,
    required this.status,
    required this.progress,
    required this.joinedAt,
    this.completedAt,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      roadmapId: map['roadmap_id'],
      title: map['title'],
      status: map['status'],
      progress: map['progress'],
      joinedAt: (map['joined_at'] as Timestamp).toDate(),
      completedAt: map['completed_at'] != null ? (map['completed_at'] as Timestamp).toDate() : null,
    );
  }
}