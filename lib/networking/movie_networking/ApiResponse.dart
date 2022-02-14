import 'package:kidsmovie/models/movie_model/movie_response.dart';

class ApiResponse {
  MovieResponse? data;
  String? error;
  Status status;
  ApiResponse({this.data, this.error, required this.status});
}

enum Status { Success, Failure }
