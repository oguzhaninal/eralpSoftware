import 'package:flutter/material.dart';

import 'Screens/home.dart';
import 'screens/profile.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class NavigationBar extends StatefulWidget {
  final int indexN;

  NavigationBar(this.indexN);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int selectedPage = 0;
  final screens = [
    Home(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedPage],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: SnakeShape.circle,
        snakeViewColor: const Color(0xfff3963d),
        unselectedItemColor: const Color(0xfff3963d),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: selectedPage,
        onTap: (indexN) => setState(() => selectedPage = indexN),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "To Do"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Profil")
        ],
      ),
    );
  }
}
