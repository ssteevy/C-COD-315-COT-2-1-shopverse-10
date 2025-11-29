import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'shops';

  // Créer une boutique
  Future<ShopModel> createShop({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required String merchantId,
    String? imageUrl,
  }) async {
    final docRef = _firestore.collection(_collection).doc();

    final shop = ShopModel(
      id: docRef.id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      merchantId: merchantId,
      createdAt: DateTime.now(),
    );

    await docRef.set(shop.toFirestore());

    return shop;
  }

  // Récupérer toutes les boutiques d'un commerçant
  Future<List<ShopModel>> getShopsByMerchant(String merchantId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('merchantId', isEqualTo: merchantId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ShopModel.fromFirestore(doc)).toList();
  }

  // Récupérer une boutique par son ID
  Future<ShopModel?> getShopById(String shopId) async {
    final doc = await _firestore.collection(_collection).doc(shopId).get();

    if (!doc.exists) return null;

    return ShopModel.fromFirestore(doc);
  }

  // Récupérer toutes les boutiques
  Future<List<ShopModel>> getAllShops() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ShopModel.fromFirestore(doc)).toList();
  }

  // Mettre à jour une boutique
  Future<void> updateShop({
    required String shopId,
    String? name,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;
    if (latitude != null) updates['latitude'] = latitude;
    if (longitude != null) updates['longitude'] = longitude;

    await _firestore.collection(_collection).doc(shopId).update(updates);
  }

  // Supprimer une boutique
  Future<void> deleteShop(String shopId) async {
    await _firestore.collection(_collection).doc(shopId).delete();
  }

  // Stream des boutiques d'un commerçant (temps réel)
  Stream<List<ShopModel>> streamShopsByMerchant(String merchantId) {
    return _firestore
        .collection(_collection)
        .where('merchantId', isEqualTo: merchantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ShopModel.fromFirestore(doc)).toList());
  }
}