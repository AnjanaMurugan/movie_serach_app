import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_list.dart';

class TmdbApi {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'f7fb78c47110588fa229cc930e23524e';
  static const String _bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmN2ZiNzhjNDcxMTA1ODhmYTIyOWNjOTMwZTIzNTI0ZSIsIm5iZiI6MTc0NzExMDE5My44MjIsInN1YiI6IjY4MjJjOTMxYTExNTMyZWZlODdlODE3MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.pcRGHCdtYvMDOHJX3Mskp8YAm68XEC2mMWQ8kRRl0Z4';
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    print("-$_baseUrl/movie/popular?page=$page&api_key=$_apiKey");
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?page=$page&api_key=$_apiKey'),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("testresponse->${response.body}");
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch popular movies: ${response.statusCode}');
    }
  }

  Future<List<Movie>> searchMovies(String query,{int page = 1}) async {
    if (query.isEmpty) {
      return [];
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?query=$query&page=$page&api_key=$_apiKey'),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies: ${response.statusCode}');
    }
  }
}
