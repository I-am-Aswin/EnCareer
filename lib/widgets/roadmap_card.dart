import 'package:flutter/material.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/screens/home/roadmap_detail_screen.dart';

class RoadmapCard extends StatelessWidget {
  final Enrollment enrollment;
  final VoidCallback? enrollCallback;
  final VoidCallback? rollbackCallback;

  const RoadmapCard({
    super.key,
    required this.enrollment,
    this.enrollCallback,
    this.rollbackCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enrollment.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: enrollment.progress / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 4),
                    Text("${enrollment.progress}% completed")
                  ],
                ),
              ),
              if (enrollCallback != null || rollbackCallback != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rollbackCallback != null ? Colors.orange : Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}