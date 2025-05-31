// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../models/restaurant_model.dart';

// class DetailPage extends StatefulWidget {
//   final Restaurant restaurant;

//   const DetailPage({required this.restaurant, super.key});

//   @override
//   State<DetailPage> createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   late bool isFavorite = false;
//   List<String> favoriteIds = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFavoriteStatus();
//   }

//   Future<void> _loadFavoriteStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     favoriteIds = prefs.getStringList('favorite_ids') ?? [];
//     setState(() {
//       isFavorite = favoriteIds.contains(widget.restaurant.id);
//     });
//   }

//   Future<void> _toggleFavorite() async {
//     final prefs = await SharedPreferences.getInstance();

//     setState(() {
//       if (isFavorite) {
//         favoriteIds.remove(widget.restaurant.id);
//       } else {
//         favoriteIds.add(widget.restaurant.id);
//       }
//       isFavorite = !isFavorite;
//     });

//     await prefs.setStringList('favorite_ids', favoriteIds);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           isFavorite
//               ? 'Berhasil ditambahkan ke favorit'
//               : 'Dihapus dari favorit',
//         ),
//         backgroundColor: isFavorite ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final r = widget.restaurant;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(r.name),
//         actions: [
//           IconButton(
//             icon: Icon(
//               isFavorite ? Icons.favorite : Icons.favorite_border,
//               color: isFavorite ? Colors.red : null,
//             ),
//             onPressed: _toggleFavorite,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
//             ),
//             const SizedBox(height: 16),
//             Text(
//               r.name,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text('Kota: ${r.city}'),
//             Text('Rating: ${r.rating}'),
//             const SizedBox(height: 16),
//             Text(r.description),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/restaurant_model.dart';

class DetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const DetailPage({required this.restaurant, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool isFavorite = false;
  List<String> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteIds = prefs.getStringList('favorite_ids') ?? [];
    setState(() {
      isFavorite = favoriteIds.contains(widget.restaurant.id);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (isFavorite) {
        favoriteIds.remove(widget.restaurant.id);
      } else {
        favoriteIds.add(widget.restaurant.id);
      }
      isFavorite = !isFavorite;
    });

    await prefs.setStringList('favorite_ids', favoriteIds);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Berhasil ditambahkan ke favorit'
              : 'Dihapus dari favorit',
        ),
        backgroundColor: isFavorite ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // warna appbar
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // ini bikin back arrow warna putih

        centerTitle: true,
        title: Text(r.name, style: const TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${r.pictureId}',
            ),
            const SizedBox(height: 16),

            // Row judul dan icon favorite di sampingnya
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    r.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                    size: 30,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text('Kota: ${r.city}'),
            Text('Rating: ${r.rating}'),
            const SizedBox(height: 16),
            Text(r.description),
          ],
        ),
      ),
    );
  }
}
