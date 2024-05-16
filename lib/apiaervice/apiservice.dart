import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ridiv_assignment/model/recipe.dart';
import 'package:ridiv_assignment/model/recipeinfo.dart';

class RecipeService {
  static const String apiKey = 'eaaed3d620be427583a02d5b96fa6e8e';

  static Future<List<Recipe>> fetchRecipes({
    required String query,
    bool? vegetarian,
    bool? vegan,
    bool? glutenFree,
    bool? dairyFree,
  }) async {
    String url =
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=$query';

    if (vegetarian == true) {
      url += '&diet=vegetarian';
    }
    if (vegan == true) {
      url += '&diet=vegan';
    }
    if (glutenFree == true) {
      url += '&intolerances=gluten';
    }
    if (dairyFree == true) {
      url += '&intolerances=dairy';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(response.body);
      final List<dynamic> recipesJson = data['results'];
      List<Recipe> recipes = [];

      for (var recipeJson in recipesJson) {
        recipes.add(Recipe.fromJson(recipeJson));
      }

      return recipes;
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  static fetchRecipeDetails(int recipeId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey&includeNutrition=true',
      ),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      return RecipeInformation.fromJson(data);
    } else {
      print(response.body);
      throw Exception('Failed to fetch recipe details');
    }
  }
}
