import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/weather_details_section.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget_custom.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load weather on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.state == WeatherState.loading && provider.currentWeather == null) {
              return const LoadingShimmer();
            }
            
            if (provider.state == WeatherState.error) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.refreshWeather(),
              );
            }
            
            if (provider.currentWeather == null) {
              return const Center(child: Text('No weather data. Search for a city or enable location.'));
            }
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CurrentWeatherCard(weather: provider.currentWeather!),
                  HourlyForecastList(forecasts: provider.forecast),
                  DailyForecastSection(forecasts: provider.forecast),
                  WeatherDetailsSection(weather: provider.currentWeather!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
