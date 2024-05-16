import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailedView extends StatefulWidget {
  final String name;
  final String imageUrl;
  final List ingredients;
  final List instructions;
  final List<NutrientInfo> nutrition;

  const DetailedView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
  });

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  @override
  Widget build(BuildContext context) {
    String nutritionText = widget.nutrition.map((nutrient) {
      return '${nutrient.name}: ${nutrient.amount}';
    }).join(', ');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageUrl.isNotEmpty
                ? Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  )
                : Container(height: 200.0, color: Colors.grey),
            SizedBox(height: 16.0),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.instructions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('${widget.instructions[index].number}'),
                  title: Text(widget.instructions[index].step!),
                );
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.ingredients.join(', '),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Nutritional Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(nutritionText),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveFavoriteRecipe(widget.name);
              },
              child: Text('Save as Favorite'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFavoriteRecipe(
    String recipeName,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites == null) {
      favorites = [];
    }
    favorites.add(recipeName);
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe saved as favorite'),
      ),
    );
  }
}

class NutrientInfo {
  final String name;
  final double amount;

  NutrientInfo({
    required this.name,
    required this.amount,
  });
}
