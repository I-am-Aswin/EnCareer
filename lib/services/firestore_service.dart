// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:en_career/models/enrollment.dart';
import 'package:en_career/models/node.dart';
import 'package:en_career/models/roadmap.dart';
import 'package:en_career/models/user.dart';

class FirestoreService {
  final CollectionReference users =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference roadmaps =
  FirebaseFirestore.instance.collection("roadmaps");
  final CollectionReference nodes =
  FirebaseFirestore.instance.collection("nodes");

  Future<AppUser> getUser(String userId) async {
    DocumentSnapshot snapshot = await users.doc(userId).get();
    return AppUser.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  Future<List<Roadmap>> getAllRoadmaps() async {
    QuerySnapshot snapshot = await roadmaps.get();
    return snapshot.docs.map((doc) {
      return Roadmap.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<Node>> getNodesForRoadmap(String roadmapId) async {
    QuerySnapshot snapshot = await nodes.where("roadmap_id", isEqualTo: roadmapId).get();
    return snapshot.docs.map((doc) {
      return Node.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> enrollInRoadmap(String userId, String roadmapId, String title) async {
    final userDoc = users.doc(userId);
    final userData = await userDoc.get();

    List<dynamic> enrollments = (userData.data() as Map<String, dynamic>)['enrolled_roadmaps'] ?? [];

    bool alreadyEnrolled = enrollments.any((e) => e['roadmap_id'] == roadmapId);

    if (!alreadyEnrolled) {
      enrollments.add({
        "roadmap_id": roadmapId,
        "title": title,
        "status": "in_progress",
        "progress": 0,
        "joined_at": DateTime.now(),
        "completed_at": null,
      });

      await userDoc.update({"enrolled_roadmaps": enrollments});
    }
  }

  Future<void> toggleNodeCompletion(String nodeId, String roadmapId, String userId) async {
    final nodeRef = users.doc(userId).collection("node_completion").doc(nodeId);
    final snapshot = await nodeRef.get();

    if (snapshot.exists) {
      final currentStatus = snapshot.data()?['status'];
      await nodeRef.update({
        'status': currentStatus == 'completed' ? 'in_progress' : 'completed',
      });
    } else {
      await nodeRef.set({
        'node_id': nodeId,
        'roadmap_id': roadmapId,
        'status': 'completed',
      });
    }
  }

  Future<Map<String, dynamic>> getNodeCompletionStatus(String userId, String roadmapId) async {
    final nodesRef = users.doc(userId).collection("node_completion");
    final snapshot = await nodesRef.where("roadmap_id", isEqualTo: roadmapId).get();

    int completedCount = 0;
    int total = snapshot.docs.length;

    for (var doc in snapshot.docs) {
      if (doc.data()['status'] == 'completed') {
        completedCount++;
      }
    }

    double progress = total > 0 ? (completedCount / total) * 100 : 0;

    return {
      "total": total,
      "completed": completedCount,
      "progress": progress.toInt(),
    };
  }

  Future<void> updateEnrollmentProgress(String userId, String roadmapId, int progress) async {
    final userDoc = users.doc(userId);
    final userData = await userDoc.get();

    List<dynamic> enrollments = (userData.data() as Map<String, dynamic>)['enrolled_roadmaps'] ?? [];

    List<dynamic> updatedEnrollments = enrollments.map((e) {
      if (e['roadmap_id'] == roadmapId) {
        return {
          ...e,
          "progress": progress,
          "status": progress == 100 ? "completed" : "in_progress",
          "completed_at": progress == 100 ? DateTime.now() : null,
        };
      }
      return e;
    }).toList();

    await userDoc.update({"enrolled_roadmaps": updatedEnrollments});
  }
}