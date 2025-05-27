// lib/screens/home/roadmap_detail_screen.dart
import 'package:en_career/models/node.dart';
import 'package:en_career/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/custom_app_bar.dart';
import '../../widgets/node_item.dart';
import 'package:en_career/services/auth_service.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final String roadmapId;
  final String title;

  const RoadmapDetailScreen({
    Key? key,
    required this.roadmapId,
    required this.title,
  }) : super(key: key);

  @override
  State<RoadmapDetailScreen> createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen> {
  late Future<List<Node>> futureNodes;
  late Future<Map<String, dynamic>> progressFuture;

  @override
  void initState() {
    super.initState();
    final firestore = FirestoreService();
    futureNodes = firestore.getNodesForRoadmap(widget.roadmapId);
    final authService = Provider.of<AuthService>(context, listen: false);
    progressFuture = firestore.getNodeCompletionStatus(authService.currentUser!.uid, widget.roadmapId);
  }

  Future<void> _toggleNode(String nodeId, String roadmapId) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestore = FirestoreService();

    await firestore.toggleNodeCompletion(nodeId, roadmapId, authService.currentUser!.uid);
    await firestore.updateEnrollmentProgress(
      authService.currentUser!.uid,
      roadmapId,
      (await progressFuture)['progress'] ?? 0,
    );

    setState(() {
      progressFuture = firestore.getNodeCompletionStatus(authService.currentUser!.uid, widget.roadmapId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: progressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                final data = snapshot.data!;
                return Column(
                  children: [
                    Text("${data['completed']} / ${data['total']} nodes completed"),
                    LinearProgressIndicator(value: data['progress'] / 100),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Learning Path", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Node>>(
                future: futureNodes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No nodes found"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final node = snapshot.data![index];
                      return NodeItem(
                        node: node,
                        onToggle: () => _toggleNode(node.id, widget.roadmapId),
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