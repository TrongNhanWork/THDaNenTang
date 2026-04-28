import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final StorageService _storageService = StorageService();
  List<String> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _storageService.getFavoriteCities();
    setState(() {
      _favoriteCities = favorites;
    });
  }

  Future<void> _saveFavorite(String city) async {
    if (!_favoriteCities.contains(city)) {
      final updatedFavorites = List<String>.from(_favoriteCities)..add(city);
      if (updatedFavorites.length > 5) {
        updatedFavorites.removeAt(0); // Keep max 5
      }
      await _storageService.saveFavoriteCities(updatedFavorites);
      setState(() {
        _favoriteCities = updatedFavorites;
      });
    }
  }
  
  Future<void> _removeFavorite(String city) async {
    final updatedFavorites = List<String>.from(_favoriteCities)..remove(city);
    await _storageService.saveFavoriteCities(updatedFavorites);
    setState(() {
      _favoriteCities = updatedFavorites;
    });
  }

  void _performSearch(String city) {
    if (city.trim().isEmpty) return;
    
    context.read<WeatherProvider>().fetchWeatherByCity(city.trim());
    _saveFavorite(city.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter city name (e.g., London)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _performSearch,
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 24),
            const Text(
              'Favorite Cities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_favoriteCities.isEmpty)
              const Text('No favorite cities yet. Search to add some!')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _favoriteCities.length,
                  itemBuilder: (context, index) {
                    final city = _favoriteCities[index];
                    return ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFavorite(city),
                      ),
                      onTap: () => _performSearch(city),
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
