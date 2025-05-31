import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['restaurants'];
      return data.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  Future<Restaurant> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Restaurant.fromJson(jsonData['restaurant']);
    } else {
      throw Exception("Failed to load detail");
    }
  }

  /////
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['restaurants'] ?? []; // cek key sesuai API
      return data.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search restaurants");
    }
  }

  ///
}
