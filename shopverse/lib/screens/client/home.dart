import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

import 'dashboard.dart';
import 'explore.dart';
import 'cart.dart';
import 'profile.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    ClientDashboardPage(),
    ClientExplorePage(),
    ClientCartPage(),
    ClientProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: CircleNavBar(
        activeIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },

        // Couleur de la bulle
        circleColor: const Color(0xFF0A9961),

        // Couleur de fond
        color: Colors.white,

        activeIcons: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.explore, color: Colors.white),
          Icon(Icons.shopping_cart, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        inactiveIcons: const [
          Icon(Icons.home, color: Colors.grey),
          Icon(Icons.explore, color: Colors.grey),
          Icon(Icons.shopping_cart, color: Colors.grey),
          Icon(Icons.person, color: Colors.grey),
        ],

        height: 60,
        circleWidth: 60,

        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),

        elevation: 10,
      ),
    );
  }
}
