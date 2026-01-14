import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/usage/viewmodels/usage_provider.dart';
import 'features/usage/screens/dashboard_screen.dart';
import 'features/onboarding/screens/get_started_screen.dart';
import 'features/onboarding/screens/lost_years_splash.dart';
import 'features/onboarding/screens/truth_setup_screen.dart';
import 'features/onboarding/screens/truth_result_screen.dart';
import 'theme/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UsageProvider()..loadUsage()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'The Lost Years',
            theme: themeNotifier.currentTheme,
            home: const GetStartedScreen(),
            routes: {
              '/reality': (context) => const RealityScreen(),
              '/truth_setup': (context) => const TruthSetupScreen(),
              '/truth_result': (context) => const TruthResultScreen(),
              '/dashboard': (context) => const DashboardScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
