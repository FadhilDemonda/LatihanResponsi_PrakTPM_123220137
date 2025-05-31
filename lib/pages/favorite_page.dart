import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/restaurant_model.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final ApiService apiService = ApiService();
  List<String> favoriteIds = [];
  List<Restaurant> favoriteRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteIds = prefs.getStringList('favorite_ids') ?? [];

    if (favoriteIds.isEmpty) {
      setState(() {
        favoriteRestaurants = [];
      });
      return;
    }

    // Load all restaurants then filter by favoriteIds
    try {
      final allRestaurants = await apiService.fetchRestaurants();
      final favs =
          allRestaurants.where((r) => favoriteIds.contains(r.id)).toList();
      setState(() {
        favoriteRestaurants = favs;
      });
    } catch (e) {
      // error handling
      setState(() {
        favoriteRestaurants = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurants')),
      body:
          favoriteRestaurants.isEmpty
              ? const Center(child: Text('Belum ada restoran favorit'))
              : ListView.builder(
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  final r = favoriteRestaurants[index];
                  return ListTile(
                    leading: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(r.name),
                    subtitle: Text('${r.city} - ⭐ ${r.rating}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(restaurant: r),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
