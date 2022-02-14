import 'dart:convert';

import 'package:http/http.dart';

const String appKey = 'ca5a2656ca4371e211bbbc5e6fef3c71';
const String appId = 'b3bf07c8';
const String base_url = 'https://api.edamam.com/search';

class RecipeService {
  Future getData(String url) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      // print('json response: ${json.decode(response.body)}');
      return response.body;
    } else {
      print('status Code: ${response.statusCode}');
    }
  }

  Future<dynamic> getRecipes(String query, int to, int from) async {
    final recipeData = getData(
        '$base_url?q=$query&app_id=$appId&app_key=$appKey&from=$from&to=$to');
    return recipeData;
  }
}
