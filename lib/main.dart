// healingbloom\lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'providers/profile_provider.dart';
import 'providers/documents_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/skin_disease_provider.dart';
import 'package:healingbloom/screens/skin_test/history_screen.dart';
import 'package:healingbloom/screens/skin_test/skin_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (context) => ProfileProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) =>
              previous ?? ProfileProvider(auth),
        ),
        // Documents Provider (depends on Auth)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DocumentsProvider>(
          create: (context) => DocumentsProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
          update: (context, authProvider, documentsProvider) =>
              documentsProvider ?? DocumentsProvider(authProvider),
        ),
        // shop Provider
        ChangeNotifierProvider<ShopProvider>(
          create: (_) => ShopProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, SkinDiseaseProvider>(
          create: (ctx) => SkinDiseaseProvider(AuthProvider()),
          update: (ctx, auth, previous) => SkinDiseaseProvider(auth),
        ),
      ],
      child: const HealingBloomApp(),
    ),
  );
}

class HealingBloomApp extends StatelessWidget {
  const HealingBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Bloom',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
      routes: {
        SkinTestScreen.routeName: (context) => const SkinTestScreen(),
        SkinTestHistoryScreen.routeName: (context) =>
            const SkinTestHistoryScreen(),
      },
    );
  }
}
