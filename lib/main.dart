// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kidsmovie/models/recipe_model/recipe_model.dart';
import 'package:kidsmovie/ui/recipe_ui/recipe_card.dart';
import 'package:kidsmovie/ui/recipe_ui/recipe_list.dart';
import 'package:logging/logging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _setupLogging();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: RecipeList(),
      ),
    );
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }
}
