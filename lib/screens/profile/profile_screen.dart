// lib/screens/profile/profile_screen.dart
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Enrollment>> futureCompletedRoadmaps;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    futureCompletedRoadmaps = fetchCompletedRoadmaps(authService.currentUser!.uid);
  }

  Future<List<Enrollment>> fetchCompletedRoadmaps(String userId) async {
    final firestore = FirestoreService();
    final userDoc = await firestore.getUser(userId);
    final enrollments = (userDoc.enrolledRoadmaps ?? [])
        .map((e) => Enrollment.fromMap(e as Map<String, dynamic>))
        .toList();

    return enrollments.where((e) => e.status == "completed").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Completed Courses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Enrollment>>(
                future: futureCompletedRoadmaps,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No completed courses yet"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final enrollment = snapshot.data![index];
                      return ListTile(
                        title: Text(enrollment.title),
                        subtitle: Text("${enrollment.progress}% completed"),
                      );
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