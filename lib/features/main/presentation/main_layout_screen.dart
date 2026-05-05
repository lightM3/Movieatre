import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({super.key, required this.navigationShell});

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: navigationShell,
      extendBody: true, // Navigation bar'ın altından da içeriğin akması için
      bottomNavigationBar: _buildGlassNavigationBar(),
    );
  }

  Widget _buildGlassNavigationBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.6),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.indigoAccent,
            unselectedItemColor: Colors.white54,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Keşfet',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dynamic_feed_outlined),
                activeIcon: Icon(Icons.dynamic_feed),
                label: 'Sosyal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Ara',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
