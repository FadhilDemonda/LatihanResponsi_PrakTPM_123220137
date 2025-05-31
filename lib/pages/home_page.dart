import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../models/restaurant_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('current_user') ?? '';
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),

      // appBar: AppBar(
      //   backgroundColor: Colors.black, // warna appbar
      //   iconTheme: const IconThemeData(
      //     color: Colors.white,
      //   ), // ini bikin back arrow warna putih

      //   centerTitle: true, // title di tengah
      //   title: Text(
      //     'Selamat Datang, $username',
      //     style: const TextStyle(color: Colors.white),
      //   ),

      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/search');
      //       },
      //       tooltip: 'Search',
      //     ),

      //     PopupMenuButton<String>(
      //       icon: const Icon(Icons.more_vert, color: Colors.red),

      //       onSelected: (value) {
      //         if (value == 'favorites') {
      //           Navigator.pushNamed(context, '/favorites');
      //         } else if (value == 'logout') {
      //           _logout();
      //         }
      //       },

      //       itemBuilder:
      //           (context) => [
      //             const PopupMenuItem(
      //               value: 'favorites',
      //               child: Text('Favorite'),
      //             ),
      //             const PopupMenuItem(value: 'logout', child: Text('Logout')),
      //           ],
      //     ),
      //   ],
      // ),
      body: FutureBuilder<List<Restaurant>>(
        future: apiService.fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          }

          final restaurants = snapshot.data ?? [];
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final r = restaurants[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(restaurant: r),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar penuh di atas, border rounded sesuai card
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Padding untuk konten teks dan rating
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    r.city,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(r.rating.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Baris paling bawah dengan icon arrow kanan di kanan bawah card
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
