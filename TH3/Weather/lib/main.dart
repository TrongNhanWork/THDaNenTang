import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'providers/weather_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Load file .env
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(),
            LocationService(),
            StorageService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

          fontFamily: 'Roboto',

          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        home: const HomeScreen(),
      ),
    );
  }
}