import 'package:flutter/material.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/widgets/roadmap_card.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:en_career/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Enrollment>> futureEnrollments;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    futureEnrollments = fetchEnrollments(authService.currentUser!.uid);
  }

  Future<List<Enrollment>> fetchEnrollments(String userId) async {
    final firestore = FirestoreService();
    final userDoc = await firestore.getUser(userId);
    return (userDoc.enrolledRoadmaps ?? [])
        .map((e) => Enrollment.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ongoing Roadmaps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Enrollment>>(
                future: futureEnrollments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) => ShimmerCard(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No ongoing roadmaps"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final enrollment = snapshot.data![index];
                      return RoadmapCard(enrollment: enrollment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 100, height: 20, color: Colors.white),
              Container(width: 40, height: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}