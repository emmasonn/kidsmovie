class Movie {
  int id;
  var vote_average;
  String title;
  String poster_path;
  String overView;
  String releaseDate;

  Movie(
      {required this.id,
      required this.vote_average,
      required this.title,
      required this.poster_path,
      required this.overView,
      required this.releaseDate});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      vote_average: json['vote_average'],
      title: json['title'],
      poster_path: json['poster_path'],
      overView: json['overview'],
      releaseDate: json['release_date'],
    );
  }
}
