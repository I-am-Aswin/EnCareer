import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadSampleData() async {
  final CollectionReference roadmaps = FirebaseFirestore.instance.collection("roadmaps");
  final CollectionReference nodes = FirebaseFirestore.instance.collection("nodes");

  await roadmaps.doc("rm_fullstack_001").set({
    "title": "Full Stack Web Developer",
    "department": "Computer Science",
    "domain": "Web Development",
    "duration": "6 months",
    "type": "Complete",
    "learners": 500,
    "updated_at": Timestamp.fromDate(DateTime.parse("2025-04-05T10:00:00Z")),
  });

  await nodes.doc("node_001").set({
    "roadmap_id": "rm_fullstack_001",
    "description": "Learn HTML & CSS basics",
    "resources": [
      {
        "id": "res_html_crash",
        "title": "HTML Crash Course",
        "link": "https://example.com/html",
        "type": "video",
        "paid": false
      },
      {
        "id": "res_css_fundamentals",
        "title": "CSS Fundamentals",
        "link": "https://example.com/css",
        "type": "article",
        "paid": true
      }
    ],
    "weightage": 10,
    "sequence_number": 1
  });

  print("✅ Sample data uploaded successfully!");
}