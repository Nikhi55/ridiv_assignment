import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  _FavoriteRecipesScreenState createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  List<String> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      setState(() {
        _favoriteRecipes = favorites;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: _favoriteRecipes.isEmpty
          ? Center(
              child: Text('No favorite recipes saved'),
            )
          : ListView.builder(
              itemCount: _favoriteRecipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_favoriteRecipes[index]),
                );
              },
            ),
    );
  }
}
