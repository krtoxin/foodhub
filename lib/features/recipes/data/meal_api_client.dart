import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/meal_category.dart';
import '../domain/meal_detail.dart';
import '../domain/meal_preview.dart';

class MealApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.mealDbBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<MealCategory>> getCategories() async {
    final response = await _dio.get(AppConstants.mealDbCategoriesEndpoint);
    final list = response.data['categories'] as List;
    return list
        .map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MealPreview>> searchMeals(String query) async {
    final response = await _dio.get(
      AppConstants.mealDbSearchEndpoint,
      queryParameters: {'s': query},
    );
    final list = response.data['meals'] as List?;
    return list
            ?.map((e) => MealPreview.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Future<List<MealPreview>> getMealsByCategory(String category) async {
    final response = await _dio.get(
      AppConstants.mealDbFilterEndpoint,
      queryParameters: {'c': category},
    );
    final list = response.data['meals'] as List?;
    return list
            ?.map((e) => MealPreview.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Future<MealDetail?> getMealById(String id) async {
    final response = await _dio.get(
      AppConstants.mealDbLookupEndpoint,
      queryParameters: {'i': id},
    );
    final list = response.data['meals'] as List?;
    if (list == null || list.isEmpty) return null;
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }

  Future<MealDetail?> getRandomMeal() async {
    final response = await _dio.get(AppConstants.mealDbRandomEndpoint);
    final list = response.data['meals'] as List?;
    if (list == null || list.isEmpty) return null;
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }
}
