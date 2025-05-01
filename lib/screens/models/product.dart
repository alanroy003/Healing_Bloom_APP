// lib/models/product.dart
class Product {
  final int id;
  final int originalId;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final String brand;
  final String skinType;
  final String concerns;

  Product({
    required this.id,
    required this.originalId,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.brand,
    required this.skinType,
    required this.concerns,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      originalId: json['original_id'],
      name: json['name'],
      category: json['category'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      imageUrl: json['image_url'],
      brand: json['brand'],
      skinType: json['skin_type'],
      concerns: json['concerns'],
    );
  }
}
