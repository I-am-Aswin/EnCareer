// lib/screens/search/roadmap_search_screen.dart
import 'package:en_career/models/roadmap.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/widgets/roadmap_card.dart';
import 'package:en_career/services/auth_service.dart';
import 'package:en_career/screens/home/roadmap_detail_screen.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoadmapSearchScreen extends StatefulWidget {
  const RoadmapSearchScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapSearchScreen> createState() => _RoadmapSearchScreenState();
}

class _RoadmapSearchScreenState extends State<RoadmapSearchScreen> {
  late Future<List<Roadmap>> futureRoadmaps;

  @override
  void initState() {
    super.initState();
    futureRoadmaps = FirestoreService().getAllRoadmaps();
  }

  void _enroll(BuildContext context, Roadmap roadmap) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestore = FirestoreService();

    await firestore.enrollInRoadmap(authService.currentUser!.uid, roadmap.id, roadmap.title);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enrolled in ${roadmap.title}")));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoadmapDetailScreen(
          roadmapId: roadmap.id,
          title: roadmap.title,
        ),
      ),
    );
  }

  String get userId => Provider.of<AuthService>(context, listen: false).currentUser!.uid;

  Future<bool> _isUserEnrolled(String userId, String roadmapId) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(userId).get();
    final List<dynamic> enrollments = (userDoc.data() as Map<String, dynamic>)['enrolled_roadmaps'] ?? [];

    return enrollments.any((e) => e['roadmap_id'] == roadmapId);
  }

  void _rollback(BuildContext context, Roadmap roadmap) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestore = FirestoreService();

    await firestore.rollbackEnrollment(authService.currentUser!.uid, roadmap.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rolled back from ${roadmap.title}")),
    );

    // Refresh UI
    setState(() {
      futureRoadmaps = firestore.getAllRoadmaps(); // reload data
    });
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

                // 👇 Add FutureBuilder to check enrollment status
                return FutureBuilder<bool>(
                  future: _isUserEnrolled(userId, roadmap.id), // 👈 We'll define this below
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    bool isEnrolled = snapshot.data ?? false;

                    return RoadmapCard(
                      enrollment: Enrollment(
                        roadmapId: roadmap.id,
                        title: roadmap.title,
                        status: isEnrolled ? "in_progress" : "not_enrolled",
                        progress: 0,
                        joinedAt: DateTime.now(),
                      ),
                      enrollCallback: () => _enroll(context, roadmap),
                      rollbackCallback: isEnrolled
                          ? () => _rollback(context, roadmap)
                          : null, // No rollback if not enrolled
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