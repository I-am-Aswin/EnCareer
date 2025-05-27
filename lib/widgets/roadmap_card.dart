// lib/widgets/roadmap_card.dart
import 'package:en_career/models/enrollment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:en_career/services/auth_service.dart';
import 'package:en_career/screens/home/roadmap_detail_screen.dart';

class RoadmapCard extends StatelessWidget {
  final Enrollment enrollment;

  const RoadmapCard({Key? key, required this.enrollment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          final authService = Provider.of<AuthService>(context, listen: false);
          final firestore = FirestoreService();
          await firestore.enrollInRoadmap(authService.currentUser!.uid, enrollment.roadmapId, enrollment.title);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoadmapDetailScreen(
                roadmapId: enrollment.roadmapId,
                title: enrollment.title,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(enrollment.title),
              Chip(label: Text("${enrollment.progress}%")),
            ],
          ),
        ),
      ),
    );
  }
}