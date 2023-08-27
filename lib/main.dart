import 'package:flutter/material.dart';
import 'package:videogames_voter/pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      themeMode: ThemeMode.light,
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomePage(),
      },
    );
  }
}
