// lib/screens/shop/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:healingbloom/screens/models/product.dart';
import '../../providers/shop_provider.dart';
import 'product_detail_screen.dart';
// import 'package:healingbloom/screens/shop/purchase_success_screen.dart';
import '../../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:healingbloom/screens/navigation/app_drawer.dart';
// import 'package:healingbloom/screens/navigation/bottom_nav_bar.dart';
// import 'package:healingbloom/screens/skin_test/skin_test_screen.dart';
// import 'package:healingbloom/screens/product_recommender/product_recommender_screen.dart';
// import 'package:healingbloom/screens/home/home_content_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Healing Bloom',
          style: GoogleFonts.playfairDisplay(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.pearlWhite,
        elevation: 0,
      ),
      body: Consumer<ShopProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(provider.error!,
                    style: TextStyle(color: AppTheme.royalPlum, fontSize: 16)),
              ),
            );
          }

          if (provider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_rounded,
                      size: 60, color: AppTheme.velvetAmethyst),
                  const SizedBox(height: 20),
                  Text('No Products Available',
                      style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) => ProductCard(
                product: provider.products[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.pearlWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppTheme.subtleShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppTheme.opulentLilac,
                  child: Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.velvetAmethyst)),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.opulentLilac,
                  child: Icon(Icons.spa_rounded,
                      color: AppTheme.velvetAmethyst, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.brand,
                      style: TextStyle(
                          color: AppTheme.champagneGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: AppTheme.royalPlum,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppTheme.lavenderMist.withAlpha(50),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(product.category.toUpperCase(),
                            style: TextStyle(
                                color: AppTheme.velvetAmethyst, fontSize: 10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
