// models/product.dart
class Product {
  final String? id;
  final String shopId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convertir en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Créer un Product depuis Firebase
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      shopId: map['shopId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null  // ← Ajouter
        ? DateTime.parse(map['updatedAt'])
        : null,
    );
  }

  // Copier avec modifications
  Product copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
