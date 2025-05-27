// lib/models/node.dart
class Resource {
  final String id;
  final String title;
  final String link;
  final String type; // video/article/book
  final bool paid;

  Resource({
    required this.id,
    required this.title,
    required this.link,
    required this.type,
    required this.paid,
  });

  factory Resource.fromMap(Map<String, dynamic> map, String id) {
    return Resource(
      id: id,
      title: map['title'],
      link: map['link'],
      type: map['type'],
      paid: map['paid'] ?? false,
    );
  }
}

class Node {
  final String id;
  final String roadmapId;
  final String description;
  final List<Resource> resources;
  final int weightage;
  final int sequenceNumber;

  Node({
    required this.id,
    required this.roadmapId,
    required this.description,
    required this.resources,
    required this.weightage,
    required this.sequenceNumber,
  });

  factory Node.fromMap(Map<String, dynamic> map, String id) {
    var list = map['resources'] as List;
    List<Resource> resourcesList = list.map((item) {
      return Resource.fromMap(item, item['id']);
    }).toList();

    return Node(
      id: id,
      roadmapId: map['roadmap_id'],
      description: map['description'],
      resources: resourcesList,
      weightage: map['weightage'] ?? 10,
      sequenceNumber: map['sequence_number'] ?? 0,
    );
  }
}