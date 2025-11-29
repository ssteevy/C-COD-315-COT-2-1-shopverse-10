import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/shop.dart';
import '../../providers/auth_provider.dart';
import '../../services/shop_service.dart';
import 'shop_form_screen.dart';
import 'shop_detail_screen.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({Key? key}) : super(key: key);

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  final ShopService _shopService = ShopService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final merchantId = authProvider.currentUser?.id;

    if (merchantId == null) {
      return const Center(
        child: Text('Please login to continue'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Shops',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.bitcoinOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<ShopModel>>(
        stream: _shopService.streamShopsByMerchant(merchantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.bitcoinOrange,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading shops',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final shops = snapshot.data ?? [];

          if (shops.isEmpty) {
            return _buildEmptyState(merchantId);
          }

          return _buildShopList(shops, merchantId);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(merchantId),
        backgroundColor: AppColors.bitcoinOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Shop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String merchantId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bitcoinOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store_outlined,
                size: 64,
                color: AppColors.bitcoinOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No shops yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first shop to start selling\nwith dynamic Bitcoin pricing!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToForm(merchantId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bitcoinOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Create Shop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopList(List<ShopModel> shops, String merchantId) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        return _buildShopCard(shop, merchantId);
      },
    );
  }

  Widget _buildShopCard(ShopModel shop, String merchantId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(shop),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image de la boutique
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.bitcoinOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: shop.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            shop.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.store,
                                size: 40,
                                color: AppColors.bitcoinOrange,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.store,
                          size: 40,
                          color: AppColors.bitcoinOrange,
                        ),
                ),
                const SizedBox(width: 16),
                // Infos de la boutique
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shop.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.bitcoinOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'GPS: ${shop.latitude.toStringAsFixed(4)}, ${shop.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Flèche
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.bitcoinOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToForm(String merchantId, {ShopModel? shop}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopFormScreen(
          merchantId: merchantId,
          shop: shop,
        ),
      ),
    );
  }

  void _navigateToDetail(ShopModel shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopDetailScreen(shop: shop),
      ),
    );
  }
}