import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    // Take only the first 8 items for the next 24 hours (assuming 3-hour intervals)
    final hourlyForecasts = forecasts.take(8).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hourly Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecasts.length,
              itemBuilder: (context, index) {
                final forecast = hourlyForecasts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(forecast.dateTime),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      CachedNetworkImage(
                        imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}.png',
                        height: 40,
                        placeholder: (context, url) => const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${forecast.temperature.round()}°',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
