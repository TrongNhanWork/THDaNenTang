import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    // Group forecasts by day and pick one (e.g., the one around noon) to represent the day
    final Map<String, ForecastModel> dailyForecastsMap = {};
    for (var forecast in forecasts) {
      final dateString = DateFormat('yyyy-MM-dd').format(forecast.dateTime);
      // Let's prefer the forecast around 12:00 PM (12:00:00)
      if (!dailyForecastsMap.containsKey(dateString) || forecast.dateTime.hour == 12) {
        dailyForecastsMap[dateString] = forecast;
      }
    }

    final dailyForecasts = dailyForecastsMap.values.toList();
    // Skip today if we are showing 5 day forecast
    if (dailyForecasts.isNotEmpty && dailyForecasts.first.dateTime.day == DateTime.now().day) {
      dailyForecasts.removeAt(0);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5-Day Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyForecasts.length,
            itemBuilder: (context, index) {
              final forecast = dailyForecasts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        DateFormat('EEEE').format(forecast.dateTime),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}.png',
                          height: 30,
                          placeholder: (context, url) => const SizedBox(width: 30, height: 30),
                          errorWidget: (context, url, error) => const Icon(Icons.error, size: 20),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: Text(
                            forecast.description,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${forecast.tempMax.round()}°',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${forecast.tempMin.round()}°',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
