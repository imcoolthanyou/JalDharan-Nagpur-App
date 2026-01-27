import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/gamification/water_hero_screen.dart';
import '../screens/community_settings/community_settings_screen.dart';
import '../screens/map_grind/map_grind_screen.dart';
import '../../core/theme/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const MapGrindScreen(),
    const WaterHeroScreen(),
    const CommunitySettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.deepAquiferBlue,
        unselectedItemColor: AppColors.mediumGrey,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            activeIcon: Icon(Icons.trending_up_rounded),
            label: 'Prediction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_rounded),
            activeIcon: Icon(Icons.public_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            activeIcon: Icon(Icons.emoji_events_rounded),
            label: 'Gamification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
