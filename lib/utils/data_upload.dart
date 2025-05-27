import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> uploadSampleData() async {
  final CollectionReference roadmaps = FirebaseFirestore.instance.collection("roadmaps");
  final CollectionReference nodes = FirebaseFirestore.instance.collection("nodes");
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  // Upload Roadmap
  // await roadmaps.doc("rm_fullstack_001").set({
  //   "title": "Full Stack Web Developer",
  //   "department": "Computer Science",
  //   "domain": "Web Development",
  //   "duration": "6 months",
  //   "type": "Complete",
  //   "learners": 500,
  //   "updated_at": Timestamp.fromDate(DateTime.parse("2025-04-05T10:00:00Z")),
  // });
  //
  // // Upload Nodes
  // await nodes.doc("node_001").set({
  //   "roadmap_id": "rm_fullstack_001",
  //   "description": "Learn HTML & CSS basics",
  //   "resources": [
  //     {
  //       "id": "res_html_crash",
  //       "title": "HTML Crash Course",
  //       "link": "https://example.com/html ",
  //       "type": "video",
  //       "paid": false
  //     },
  //     {
  //       "id": "res_css_fundamentals",
  //       "title": "CSS Fundamentals",
  //       "link": "https://example.com/css ",
  //       "type": "article",
  //       "paid": true
  //     }
  //   ],
  //   "weightage": 10,
  //   "sequence_number": 1
  // });
  //
  // await nodes.doc("node_002").set({
  //   "roadmap_id": "rm_fullstack_001",
  //   "description": "JavaScript Essentials",
  //   "resources": [
  //     {
  //       "id": "res_js_intro",
  //       "title": "Intro to JavaScript",
  //       "link": "https://example.com/js-intro ",
  //       "type": "video",
  //       "paid": false
  //     },
  //     {
  //       "id": "res_js_exercises",
  //       "title": "JS Exercises",
  //       "link": "https://example.com/js-exercises ",
  //       "type": "book",
  //       "paid": true
  //     }
  //   ],
  //   "weightage": 10,
  //   "sequence_number": 2
  // });

  // Upload User
  await users.doc("e5BUOKarkBR0DAbJphI559C7jK83").set({
    "username": "Root",
    "email": "root@gmail.com",
    "domain": "Web Development",
    "stream": "Frontend",
    "current_stage": "Beginner",
    "created_at": Timestamp.fromDate(DateTime.parse("2025-04-01T09:00:00Z")),
    "enrolled_roadmaps": [
      {
        "roadmap_id": "rm_fullstack_001",
        "title": "Full Stack Web Developer",
        "status": "in_progress",
        "progress": 30,
        "joined_at": Timestamp.fromDate(DateTime.parse("2025-04-02T10:00:00Z")),
        "completed_at": null
      }
    ]
  });

  // Upload Node Completion
  await users.doc("e5BUOKarkBR0DAbJphI559C7jK83").collection("node_completion").doc("node_001").set({
    "node_id": "node_001",
    "roadmap_id": "rm_fullstack_001",
    "status": "completed"
  });

  print("✅ Sample data uploaded successfully!");
}