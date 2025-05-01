import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/auth_provider.dart';
import 'package:healingbloom/screens/auth/sign_in_screen.dart';
import 'package:healingbloom/theme/app_theme.dart';
import 'package:healingbloom/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _navigateToNext();
  }

  void _navigateToNext() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => authProvider.isAuthenticated
              ? const HomeScreen()
              : const SignInScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.lavenderMist, AppTheme.opulentLilac],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/Logo.png',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.spa, size: 100, color: AppTheme.royalPlum),
              ),
              const SizedBox(height: 30),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.royalPlum),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
