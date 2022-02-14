import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
class ApiRecipeQuery {
  @JsonKey(name: 'q')
  String query;
  int from;
  int to;
  int count;
  bool more;
  List<ApiHits> hits;

  ApiRecipeQuery({
    required this.query,
    required this.from,
    required this.to,
    required this.count,
    required this.more,
    required this.hits,
  });

  factory ApiRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeQueryFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRecipeQueryToJson(this);
}

@JsonSerializable()
class ApiHits {
  ApiRecipe recipe;

  ApiHits({required this.recipe});

  factory ApiHits.fromJson(Map<String, dynamic> json) =>
      _$ApiHitsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiHitsToJson(this);
}

@JsonSerializable()
class ApiRecipe {
  String label;
  String image;
  String url;
  List<ApiIngredient> ingredients;
  double calories;
  double totalTime;
  double totalWeight;

  ApiRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalTime,
    required this.totalWeight,
  });

  factory ApiRecipe.fromJson(Map<String, dynamic> json) =>
      _$ApiRecipeFromJson(json);

  Map<String, dynamic> toJson() => _$ApiRecipeToJson(this);

  String getCalories(double? calories) {
    if (calories == null) {
      return '0 KCAL';
    }
    return calories.floor().toString() + ' KCAL';
  }

  String getWeight(double? weight) {
    if (weight == null) {
      return '0g';
    }
    return weight.floor().toString() + 'g';
  }
}

@JsonSerializable()
class ApiIngredient {
  @JsonKey(name: 'text')
  String name;
  double weight;

  ApiIngredient({required this.name, required this.weight});

  factory ApiIngredient.fromJson(Map<String, dynamic> json) =>
      _$ApiIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$ApiIngredientToJson(this);
}
