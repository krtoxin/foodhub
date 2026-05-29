class AppConstants {
  static const String mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String mealDbCategoriesEndpoint = '/categories.php';
  static const String mealDbSearchEndpoint = '/search.php';
  static const String mealDbFilterEndpoint = '/filter.php';
  static const String mealDbLookupEndpoint = '/lookup.php';
  static const String mealDbRandomEndpoint = '/random.php';

  static const String prefTheme = 'theme_mode';
  static const String prefLanguage = 'language';
  static const String prefLastSearch = 'last_search';
  static const String prefRandomMealId = 'random_meal_id';
  static const String prefRandomMealDate = 'random_meal_date';
  static const String prefFavorites = 'favorites_list';
  static const String prefMyRecipes = 'my_recipes_list';

  static const String firestoreFavorites = 'favorites';
  static const String firestoreMyRecipes = 'my_recipes';
  static const String firestoreUsers = 'users';

  static const String storageProfilePhotos = 'profile_photos';
  static const String storageRecipePhotos = 'recipe_photos';
}
