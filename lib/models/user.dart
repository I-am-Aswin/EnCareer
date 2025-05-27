// lib/models/user.dart
class AppUser {
  final String id;
  final String username;
  final String email;
  final String? domain;
  final String? stream;
  final String? currentStage;
  final List<dynamic>? enrolledRoadmaps;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.domain,
    this.stream,
    this.currentStage,
    this.enrolledRoadmaps,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      username: map['username'],
      email: map['email'],
      domain: map['domain'],
      stream: map['stream'],
      currentStage: map['current_stage'],
      enrolledRoadmaps: map['enrolled_roadmaps'],
    );
  }
}