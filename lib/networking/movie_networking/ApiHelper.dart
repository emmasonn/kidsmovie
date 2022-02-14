// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kidsmovie/models/movie_model/movie_response.dart';
import 'package:kidsmovie/networking/movie_networking/ApiResponse.dart';

class ApiHelper {
  final base_url = 'https://api.themoviedb.org/3/movie/';

  Future<ApiResponse> fetchMovies(String url) async {
    try {
      final response = await http.get(Uri.parse(base_url + url));
      return _requestResponse(response);
    } on SocketException {
      return ApiResponse(
          status: Status.Failure, error: "No Internet Connection");
    }
  }

  ApiResponse _requestResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse(
            status: Status.Success,
            data: MovieResponse.fromJson(json.decode(response.body)),
            error: null);
      default:
        throw Exception("${json.decode(response.body)['message']}");
    }
  }
}
