// lib/screens/shop/purchase_success_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:healingbloom/theme/app_theme.dart';

class PurchaseSuccessScreen extends StatelessWidget {
  const PurchaseSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 32),
              Text(
                'Purchase Successful!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Your order has been confirmed\nWe will prepare your luxury package with care',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textColor.withAlpha(200),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
