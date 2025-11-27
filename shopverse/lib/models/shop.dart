import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String merchantId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShopModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.merchantId,
    required this.createdAt,
    this.updatedAt,
  });

 
  factory ShopModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ShopModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      merchantId: data['merchantId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'merchantId': merchantId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }


  ShopModel copyWith({
    String? name,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      merchantId: merchantId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ShopModel(id: $id, name: $name, merchantId: $merchantId)';
  }
}