import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'core/services/socket_service.dart';
import 'firebase_options.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/rainwater_harvesting/rainwater_harvesting_screen.dart';
import 'presentation/screens/analytics/analytics_screen.dart';
import 'presentation/screens/gamification/water_hero_screen.dart';
import 'presentation/screens/knowledge_hub/knowledge_hub_screen.dart';
import 'presentation/screens/community_settings/community_settings_screen.dart';
import 'presentation/screens/jal_shayak/jal_shayak_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';
import 'presentation/screens/map_grind/map_grind_screen.dart';
import 'presentation/navigation/main_navigation_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final socketService = SocketService();

    return MultiProvider(
      providers: [
        // Socket Service Provider
        ChangeNotifierProvider<SocketService>.value(value: socketService),
      ],
      child: MaterialApp(
        title: 'Jal Dharan',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasData) {
              // User is logged in - Initialize Socket.IO
              Future.microtask(() {
                final socketService = Provider.of<SocketService>(context, listen: false);
                if (!socketService.isConnected && !socketService.isConnecting) {
                  socketService.initSocket();
                }
              });

              return const MainNavigationScreen();
            } else {
              // User is not logged in
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const MainNavigationScreen(),
          '/rainwater_harvesting': (context) => const RainwaterHarvestingScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
          '/water_hero': (context) => const WaterHeroScreen(),
          '/knowledge_hub': (context) => const KnowledgeHubScreen(),
          '/community_settings': (context) => const CommunitySettingsScreen(),
          '/jal_shayak': (context) => const JalShayakScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/map_grind': (context) => const MapGrindScreen(),
        },
      ),
    );
  }
}
