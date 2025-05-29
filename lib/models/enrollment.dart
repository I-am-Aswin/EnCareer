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
      progress: map['progress'] ?? 0,
      joinedAt: (map['joined_at'] is Timestamp) ? map['joined_at'].toDate() : DateTime.parse(map['joined_at']),
      completedAt: map['completed_at'] != null
          ? (map['completed_at'] is Timestamp)
          ? map['completed_at'].toDate()
          : DateTime.parse(map['completed_at'])
          : null,
    );
  }
}