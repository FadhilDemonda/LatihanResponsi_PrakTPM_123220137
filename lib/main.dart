import 'package:flutter/material.dart';
import 'package:latresponsi/pages/register_page.dart';
import 'package:latresponsi/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';
//import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/favorite_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('username');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/favorites': (context) => const FavoritePage(),
        '/search': (context) => const SearchPage(), // Tambah ini
      },
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data == true) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
