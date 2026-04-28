import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildDetailItem(
                context,
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${weather.humidity}%',
              ),
              _buildDetailItem(
                context,
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed} m/s',
              ),
              _buildDetailItem(
                context,
                icon: Icons.speed,
                label: 'Pressure',
                value: '${weather.pressure} hPa',
              ),
              if (weather.visibility != null)
                _buildDetailItem(
                  context,
                  icon: Icons.visibility,
                  label: 'Visibility',
                  value: '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
                ),
              if (weather.cloudiness != null)
                _buildDetailItem(
                  context,
                  icon: Icons.cloud,
                  label: 'Cloudiness',
                  value: '${weather.cloudiness}%',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
