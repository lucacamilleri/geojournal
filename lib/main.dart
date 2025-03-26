// Importing the necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

// Main entry point of the application
// where Firebase is initialized and the app is run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GeoJournalApp());
}

// A Stateless widget that builds the MaterialApp
// giving the application a title, a theme and 
// attaching the HomeScreen as the home page
class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoJournal',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 116, 139),
          surface: const Color.fromARGB(255, 245, 245, 245),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 34, 116, 139),
          surface: const Color.fromARGB(255, 245, 245, 245),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 21, 21, 21),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
