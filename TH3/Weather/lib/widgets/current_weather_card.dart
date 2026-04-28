import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  
  const CurrentWeatherCard({Key? key, required this.weather}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
          ),
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
  
  LinearGradient _getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFFFDB813), Color(0xFF87CEEB)], // Sunny colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)], // Rainy colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)], // Cloudy colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return const LinearGradient(
          colors: [Color(0xFFE2E8F0), Color(0xFFFFFFFF)], // Snow colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)], // Night/Default colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
