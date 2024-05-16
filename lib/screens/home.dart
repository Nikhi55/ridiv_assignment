import 'package:flutter/material.dart';
import 'package:ridiv_assignment/apiaervice/apiservice.dart';
import 'package:ridiv_assignment/model/recipe.dart';
import 'package:ridiv_assignment/model/recipeinfo.dart';
import 'package:ridiv_assignment/screens/detailview.dart';
import 'package:ridiv_assignment/screens/favorite.dart';
import 'package:ridiv_assignment/widgets/recipecard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  bool _showFilter = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _glutenFree = false;
  bool _dairyFree = false;

  final List<bool> _filterSelection = [false, false, false, false];
  final List<String> _filterOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Dairy Free'
  ];

  void _searchRecipes(String query) async {
    try {
      List<Recipe> recipes = await RecipeService.fetchRecipes(
        query: query,
        vegetarian: _vegetarian,
        vegan: _vegan,
        glutenFree: _glutenFree,
        dairyFree: _dairyFree,
      );
      setState(() {
        _recipes = recipes;
        _showFilter = true; // Show filter options when recipes are loaded
      });
    } catch (e) {
      print('Error fetching recipes: $e');
      // Handle error gracefully
    }
  }

  void _navigateToDetailedView(int recipeInformation) async {
    RecipeInformation detailedRecipe =
        await RecipeService.fetchRecipeDetails(recipeInformation);

    List<NutrientInfo> nutrients = [];
    if (detailedRecipe.nutrition != null &&
        detailedRecipe.nutrition!.nutrients != null) {
      nutrients = detailedRecipe.nutrition!.nutrients!
          .map((nutrient) => NutrientInfo(
                name: nutrient.name ?? '',
                amount: nutrient.amount ?? 0,
              ))
          .toList();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedView(
          name: "${detailedRecipe.title}",
          imageUrl: "${detailedRecipe.image}",
          instructions: detailedRecipe.analyzedInstructions != null
              ? detailedRecipe.analyzedInstructions!
                  .map((instruction) => instruction.steps)
                  .expand((steps) => steps!)
                  .toList()
              : [],
          ingredients: detailedRecipe.extendedIngredients != null
              ? detailedRecipe.extendedIngredients!
                  .map((ingredient) =>
                      '${ingredient.name} (${ingredient.aisle})')
                  .toList()
              : [],
          nutrition: nutrients,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => FavoriteRecipesScreen(),
            ),
          );
        },
        child: Icon(Icons.favorite_outline_rounded),
      ),
      appBar: AppBar(
        title: Text('Recipe Finder'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for recipes...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String query = _searchController.text.trim();
                    if (query.isNotEmpty) {
                      _searchRecipes(query);
                    }
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: _showFilter,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilterChip(
                      label: Text(_filterOptions[index]),
                      selected: _filterSelection[index],
                      onSelected: (selected) {
                        setState(() {
                          _filterSelection[index] = selected;
                          _applyFilters();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  name: "${_recipes[index].title}",
                  imageUrl: "${_recipes[index].image}",
                  description: "${_recipes[index].id}",
                  onTap: () {
                    _navigateToDetailedView(_recipes[index].id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    _vegetarian = _filterSelection[0];
    _vegan = _filterSelection[1];
    _glutenFree = _filterSelection[2];
    _dairyFree = _filterSelection[3];

    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _searchRecipes(query);
    }
  }
}
