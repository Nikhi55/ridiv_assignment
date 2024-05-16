import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final Function? onTap;

  const RecipeCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      child: ListTile(
        leading: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              )
            : Container(width: 100.0, height: 100.0, color: Colors.grey),
        title: Text(name),
        subtitle: Text(description),
        onTap: () {
          onTap!();
        },
      ),
    );
  }
}
