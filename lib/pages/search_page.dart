import 'package:flutter/material.dart';

import '../models/restaurant_model.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Restaurant> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await apiService.searchRestaurants(query);
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mencari restoran';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Restoran'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text(_errorMessage))
            else if (_results.isEmpty)
              const Center(child: Text('Tidak ada hasil'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final r = _results[index];
                    return ListTile(
                      leading: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                        width: 60,
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
              ),
          ],
        ),
      ),
    );
  }
}
