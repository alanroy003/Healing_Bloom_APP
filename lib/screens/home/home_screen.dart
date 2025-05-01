// healingbloom\lib\screens\home\home_screen.dart
import 'package:flutter/material.dart';
// import 'package:healingbloom/theme/app_theme.dart';
import 'package:healingbloom/screens/navigation/app_drawer.dart';
import 'package:healingbloom/screens/navigation/bottom_nav_bar.dart';
import 'package:healingbloom/screens/shop/product_list_screen.dart';
import 'package:healingbloom/screens/skin_test/skin_test_screen.dart';
import 'package:healingbloom/screens/product_recommender/product_recommender_screen.dart';
import 'package:healingbloom/screens/home/home_content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContentScreen(),
    const SkinTestScreen(),
    const ProductRecommenderScreen(),
    const ProductListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      endDrawer: const AppDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
    );
  }
}
