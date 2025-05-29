// lib/widgets/roadmap_card.dart
import 'package:flutter/material.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/screens/home/roadmap_detail_screen.dart';

class RoadmapCard extends StatelessWidget {
  final Enrollment enrollment;
  final VoidCallback? enrollCallback;
  final VoidCallback? rollbackCallback;

  const RoadmapCard({
    Key? key,
    required this.enrollment,
    this.enrollCallback,
    this.rollbackCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {

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
              Expanded(child: Text(enrollment.title)),
              Chip(label: Text("${enrollment.progress}%")),
              const SizedBox(width: 10),
              if (enrollCallback != null || rollbackCallback != null)
                ElevatedButton.icon(
                  onPressed: () {
                    if (rollbackCallback != null) {
                      rollbackCallback!();
                    } else if (enrollCallback != null) {
                      enrollCallback!();
                    }
                  },
                  icon: Icon(
                    rollbackCallback != null ? Icons.undo : Icons.add,
                  ),
                  label: Text(
                    rollbackCallback != null ? "Rollback" : "Enroll",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}