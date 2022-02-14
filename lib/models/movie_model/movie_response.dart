import 'package:kidsmovie/models/movie.dart';
import 'package:kidsmovie/models/movie_model/movie.dart';

class MovieResponse {
  int page;
  List<Movie> movies;
  MovieResponse({required this.page, required this.movies});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'],
      movies: json['results'].map((e) => Movie.fromJson(e)).toList(),
    );
  }

  List<Movie> mapToMovies(List<Map<String, dynamic>> json) =>
      json.map((e) => Movie.fromJson(e)).toList();
}
