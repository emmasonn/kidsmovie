import 'dart:convert';
import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:kidsmovie/networking/recipe_networking/ApiResult.dart';
import 'package:kidsmovie/networking/recipe_networking/new_recipe_service.dart';
import 'package:kidsmovie/util/CustomDropDownMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../networking/recipe_networking/recipe_service.dart';
import './recipe_card.dart';
import '../../models/recipe_model/recipe_model.dart';
import '../recipe_ui/recipe_card.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late TextEditingController _searchTextController;
  final prefKey = "previousSearches";
  List<ApiHits> currentSearchList = [];
  List<String> previousSearches = [];
  int currentEndPosition = 20;
  int pageCount = 20;
  int currentStartPosition = 0;
  bool loading = false;
  bool inErrorState = false;
  bool hasMore = false;
  int currentCount = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPreviousSearches();
    _searchTextController = TextEditingController(text: '');
    _scrollController.addListener(() {
      final triggerFetchMoreSize =
          0.7 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        if (hasMore &&
            currentEndPosition < currentCount &&
            !loading &&
            !inErrorState) {
          setState(() {
            loading = true;
            currentStartPosition = currentEndPosition;
            currentEndPosition =
                min(currentStartPosition + pageCount, currentCount);
          });
        }
      }
    });
  }

  void savePreviousSearches() async {
    final pref = await SharedPreferences.getInstance();
    pref.setStringList(prefKey, previousSearches);
  }

  void getPreviousSearches() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(prefKey)) {
      final searches = pref.getStringList(prefKey);
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRecipeSearchBar(context),
              _buildRecipeListRoader()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
    savePreviousSearches();
  }

  Widget _buildRecipeSearchBar(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchTextController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Recipe',
                      ),
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      onSubmitted: (value) {
                        startSearch(_searchTextController.text.trim());
                        if (!previousSearches.contains(value) && value != '') {
                          previousSearches.add(value);
                          savePreviousSearches();
                        }
                      },
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[600],
                    ),
                    onSelected: (value) {
                      _searchTextController.text = value;
                      startSearch(value);
                    },
                    itemBuilder: (BuildContext context) {
                      return previousSearches
                          .map<CustomDropDownMenuItem<String>>((String value) {
                        return CustomDropDownMenuItem(
                          value: value,
                          text: value,
                          callback: () {
                            setState(
                              () {
                                previousSearches.remove(value);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ApiRecipeQuery> getRecipeData(String query, int from, int to) async {
    try {
      final recipeJson = await RecipeService().getRecipes(query, to, from);
      final jsonMap = json.decode(recipeJson);
      return ApiRecipeQuery.fromJson(jsonMap);
    } on Exception catch (_, e) {
      print('Exception Caught: $e');
      return Future.error(e);
    }
  }

  //this function contains a Future builder that was used to load the recipe from the apiService
  Widget _buildRecipeListRoader() {
    if (_searchTextController.text.length < 3) {
      return Container();
    }
    return FutureBuilder<Response<ApiResult<ApiRecipeQuery>>>(
      future: NewRecipeService.create().queryRecipes(
        _searchTextController.text.trim(),
        currentStartPosition,
        currentEndPosition,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Expanded(
              child: Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.3,
                ),
              ),
            );
          }
          loading = false;
          final query = snapshot.data?.body;
          if (query is Error) {
            inErrorState = false;
            return _buildSearchList(context, currentSearchList);
          }
          final data = (query as Success).value;
          if (data != null) {
            currentCount = data.count;
            hasMore = data.more;
            currentSearchList.addAll(data.hits);
            if (data.to < currentEndPosition) {
              currentEndPosition = data.to;
            }
          }
          return _buildSearchList(context, currentSearchList);
        } else {
          if (currentCount == 0) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return _buildSearchList(context, currentSearchList);
          }
        }
      },
    );
  }

  void startSearch(String value) {
    setState(() {
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      currentCount = 0;
      currentSearchList.clear();
      hasMore = true;
      value = value.trim();
      if (!previousSearches.contains(value)) {
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  Widget _buildSearchList(BuildContext context, List<ApiHits> hits) {
    final size = MediaQuery.of(context).size;
    const itemHeight = 320;
    final itemWidth = size.width / 2;
    return Flexible(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight),
          ),
          itemCount: hits.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildRecipeCard(context, hits, index);
          }),
    );
  }

  Widget _buildRecipeCard(BuildContext context, List<ApiHits> hits, int index) {
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return Container();
          }),
        );
      },
      child: recipeCard(context, recipe),
    );
  }
}
