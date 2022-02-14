import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kidsmovie/models/recipe_model/recipe_model.dart';

Widget recipeCard(BuildContext context, ApiRecipe recipe) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          child: CachedNetworkImage(
            imageUrl: recipe.image,
            height: 210,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            recipe.label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            recipe.getCalories(recipe.calories),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0)
      ],
    ),
  );
}
