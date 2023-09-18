import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/movie_details_model.dart';
import '../models/movies_model.dart';

Future<List<Movie>> fetchTrendingMovies(BuildContext context, int page) async {
  log('entered to function');

  const apiKey = '3aa2c997ec3eb7851fa0e377b062b620';
  const language = 'en-US';
  final baseUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey&language=$language&page=$page';

  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);

    final List<Movie> movies = (jsonData['results'] as List)
        .map((item) => Movie.fromJson(item))
        .toList();
    log(movies.toString());
    return movies;
  } else {
    log('error getting movies');

    return [];
  }
}

Future<MovieDetailsModel?> fetchMovieDetails(int movieId) async {
  const apiKey = '3aa2c997ec3eb7851fa0e377b062b620';
  final baseUrl = 'https://api.themoviedb.org/3/movie/$movieId';
  final uri = Uri.parse(baseUrl).replace(queryParameters: {
    'api_key': apiKey,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    return MovieDetailsModel.fromJson(jsonBody);
  } else {
    log(' Status code: ${response.statusCode}');
    return null;
  }
}
