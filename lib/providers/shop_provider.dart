// lib/providers/shop_provider.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healingbloom/screens/models/product.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  final String _baseUrl = "http://192.168.1.73:8000/api/shopping";

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load products: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching products: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/$id/'));

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkoutProduct(int productId) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      await http.post(
        Uri.parse('$_baseUrl/checkout/'),
        body: jsonEncode({'product_id': productId}),
        headers: {'Content-Type': 'application/json'},
      );

      return true;
    } catch (e) {
      return true;
    }
  }
}
