// lib/widgets/node_item.dart
import 'package:en_career/models/node.dart';
import 'package:flutter/material.dart';
import 'resource_card.dart';

class NodeItem extends StatelessWidget {
  final Node node;
  final VoidCallback onToggle;

  const NodeItem({Key? key, required this.node, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Step ${node.sequenceNumber}: ${node.description}"),
      children: node.resources.map((res) => ResourceCard(resource: res)).toList(),
      trailing: IconButton(icon: const Icon(Icons.check_circle_outline), onPressed: onToggle),
    );
  }
}