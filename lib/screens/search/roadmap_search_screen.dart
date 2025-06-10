import 'package:en_career/models/roadmap.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/widgets/roadmap_card.dart';
import 'package:en_career/services/auth_service.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/screens/home/roadmap_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoadmapSearchScreen extends StatefulWidget {
  const RoadmapSearchScreen({super.key});

  @override
  State<RoadmapSearchScreen> createState() => _RoadmapSearchScreenState();
}

class _RoadmapSearchScreenState extends State<RoadmapSearchScreen> {
  late Future<List<Roadmap>> futureRoadmaps;
  late String userId;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    userId = authService.currentUser!.uid;
    futureRoadmaps = FirestoreService().getAllRoadmaps();
  }

  void _enroll(BuildContext context, Roadmap roadmap) async {
    final firestore = FirestoreService();
    final authService = Provider.of<AuthService>(context, listen: false);

    await firestore.enrollInRoadmap(authService.currentUser!.uid, roadmap.id, roadmap.title);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Enrolled in ${roadmap.title}")),
    );

    setState(() {
      futureRoadmaps = firestore.getAllRoadmaps(); // refresh
    });
  }

  void _rollback(BuildContext context, Roadmap roadmap) async {
    final firestore = FirestoreService();
    final authService = Provider.of<AuthService>(context, listen: false);

    await firestore.rollbackEnrollment(authService.currentUser!.uid, roadmap.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rolled back from ${roadmap.title}")),
    );

    setState(() {
      futureRoadmaps = firestore.getAllRoadmaps(); // refresh
    });
  }

  Future<Map<String, dynamic>> getEnrollmentStatus(String roadmapId) async {
    final firestore = FirestoreService();
    final progressData = await firestore.getNodeCompletionStatus(userId, roadmapId);
    return {
      'isEnrolled': progressData['progress'] > 0,
      'progress': progressData['progress'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore Roadmaps")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Roadmap>>(
          future: futureRoadmaps,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No roadmaps found"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final roadmap = snapshot.data![index];

                return FutureBuilder<Map<String, dynamic>>(
                  future: getEnrollmentStatus(roadmap.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text("Checking..."),
                      );
                    }

                    final data = snapshot.data!;
                    final isEnrolled = data['isEnrolled'];
                    final progress = data['progress'];

                    return RoadmapCard(
                      enrollment: Enrollment(
                        roadmapId: roadmap.id,
                        title: roadmap.title,
                        status: isEnrolled ? "in_progress" : "not_enrolled",
                        progress: progress,
                        joinedAt: DateTime.now(),
                      ),
                      enrollCallback: () => _enroll(context, roadmap),
                      rollbackCallback: isEnrolled ? () => _rollback(context, roadmap) : null,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}