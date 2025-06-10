// lib/widgets/resource_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCard extends StatelessWidget {
  final resource;

  const ResourceCard({super.key, required this.resource});

  void _launchURL() async {
    final url = Uri.parse(resource.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(resource.title),
        subtitle: Text("${resource.type} - ${resource.paid ? "Paid" : "Free"}"),
        trailing: const Icon(Icons.open_in_new),
        onTap: _launchURL,
      ),
    );
  }
}