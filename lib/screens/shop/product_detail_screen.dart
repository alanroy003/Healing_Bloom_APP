// lib/screens/shop/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:healingbloom/screens/models/product.dart';
import 'package:healingbloom/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:healingbloom/providers/shop_provider.dart';
import 'package:healingbloom/screens/shop/purchase_success_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.pearlWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.royalPlum),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProductImage(),
            _buildProductDetails(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPurchaseButton(context),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.opulentLilac.withAlpha(50),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: CachedNetworkImage(
        // ✅ Correct placement
        imageUrl: product.imageUrl,
        fit: BoxFit.contain,
        placeholder: (_, __) => Center(
          child: CircularProgressIndicator(color: AppTheme.velvetAmethyst),
        ),
        errorWidget: (_, __, ___) => Icon(
          Icons.spa_rounded,
          color: AppTheme.velvetAmethyst,
          size: 100,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.brand,
              style: TextStyle(
                  color: AppTheme.champagneGold,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(product.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.royalPlum)),
              Chip(
                label: Text(product.category.toUpperCase()),
                backgroundColor: AppTheme.lavenderMist.withAlpha(50),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailSection('Skin Type', product.skinType),
          const SizedBox(height: 16),
          _buildConcernsSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: AppTheme.velvetAmethyst, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(content,
            style: const TextStyle(fontSize: 16, color: AppTheme.textColor)),
      ],
    );
  }

  Widget _buildConcernsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Benefits',
            style: TextStyle(
                color: AppTheme.velvetAmethyst, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.concerns
              .split(',')
              .map((concern) => Chip(
                    label: Text(concern.trim()),
                    backgroundColor: AppTheme.lavenderMist.withAlpha(50),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () async {
          final shopProvider = context.read<ShopProvider>();

          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          final success = await shopProvider.checkoutProduct(product.id);

          if (!context.mounted) return;
          Navigator.pop(context); // Dismiss loading indicator

          if (success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PurchaseSuccessScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Checkout failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.royalPlum,
          foregroundColor: AppTheme.pearlWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text('Purchase Now', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
