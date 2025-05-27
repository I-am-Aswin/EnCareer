// lib/models/roadmap.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Roadmap {
  final String id;
  final String title;
  final String department;
  final String domain;
  final String duration;
  final String type;
  final int learners;
  final DateTime updatedAt;

  Roadmap({
    required this.id,
    required this.title,
    required this.department,
    required this.domain,
    required this.duration,
    required this.type,
    required this.learners,
    required this.updatedAt,
  });

  factory Roadmap.fromMap(Map<String, dynamic> map, String id) {
    return Roadmap(
      id: id,
      title: map['title'],
      department: map['department'],
      domain: map['domain'],
      duration: map['duration'],
      type: map['type'],
      learners: map['learners'] ?? 0,
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }
}