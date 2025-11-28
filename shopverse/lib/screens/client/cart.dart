

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ClientCartPage extends StatefulWidget {
  const ClientCartPage({super.key});

  @override
  State<ClientCartPage> createState() => _ClientCartPageState();
}

class _ClientCartPageState extends State<ClientCartPage> {
  // Exemple de produits dans le panier
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'iPhone 15 Pro Max',
      shopName: 'Tech Store Paris',
      basePrice: 1199.00,
      quantity: 1,
      imageUrl: '',
    ),
    CartItem(
      id: '2',
      name: 'MacBook Pro M3',
      shopName: 'Tech Store Paris',
      basePrice: 2499.00,
      quantity: 1,
      imageUrl: '',
    ),
  ];

  // Prix Bitcoin simulé
  final double _bitcoinPrice = 45220.77;
  final double _bitcoinChange = 2.3;

  @override
  Widget build(BuildContext context) {
    final subtotal = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.basePrice * item.quantity),
    );
    final delivery = 5.00;
    final total = subtotal + delivery;

    final isEmpty = _cartItems.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
        actions: [
          if (!isEmpty)
            TextButton.icon(
              onPressed: () {
                // Vider le panier
                _showClearCartDialog();
              },
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text('Vider'),
            ),
        ],
      ),
      body: isEmpty ? _buildEmptyCart() : _buildCartContent(subtotal, delivery, total),
      bottomNavigationBar: isEmpty
          ? null
          : _buildBottomBar(context, total),
    );
  }

  // Panier vide
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'Votre panier est vide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des produits pour commencer',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Retour à l'accueil
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Découvrir les boutiques'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bitcoinOrange,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contenu du panier
  Widget _buildCartContent(double subtotal, double delivery, double total) {
    return Column(
      children: [
        // Prix Bitcoin en temps réel
        _buildBitcoinBanner(),

        // Liste des produits
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItemCard(_cartItems[index]);
            },
          ),
        ),

        // Résumé du panier
        _buildSummary(subtotal, delivery, total),
      ],
    );
  }

  // Bannière Bitcoin
  Widget _buildBitcoinBanner() {
    final isUp = _bitcoinChange > 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isUp ? AppColors.btcUp : AppColors.btcDown).withValues(alpha: 0.1),
            AppColors.bitcoinOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.bitcoinOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            color: isUp ? AppColors.btcUp : AppColors.btcDown,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.currency_bitcoin,
                      color: AppColors.bitcoinOrange,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '\$${_bitcoinPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isUp ? AppColors.btcUp : AppColors.btcDown)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 12,
                            color: isUp ? AppColors.btcUp : AppColors.btcDown,
                          ),
                          Text(
                            '${_bitcoinChange.abs()}%',
                            style: TextStyle(
                              color: isUp ? AppColors.btcUp : AppColors.btcDown,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isUp
                      ? 'Les prix augmentent avec le Bitcoin !'
                      : 'Les prix baissent, profitez-en !',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card produit dans le panier
  Widget _buildCartItemCard(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image du produit
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imageUrl.isEmpty
                  ? const Icon(Icons.shopping_bag, size: 32, color: Colors.grey)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Informations produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.store, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        item.shopName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prix
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${item.basePrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.bitcoinOrange,
                            ),
                          ),
                          Text(
                            '≈ ${(item.basePrice / _bitcoinPrice).toStringAsFixed(6)} BTC',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      // Quantité
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  }
                                });
                              },
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                setState(() {
                                  item.quantity++;
                                });
                              },
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bouton supprimer
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() {
                  _cartItems.remove(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Résumé
  Widget _buildSummary(double subtotal, double delivery, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Sous-total', subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Livraison', delivery),
          const Divider(height: 24),
          _buildSummaryRow('Total', total, isTotal: true),
          const SizedBox(height: 4),
          Text(
            '≈ ${(total / _bitcoinPrice).toStringAsFixed(6)} BTC',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.bitcoinOrange : Colors.black,
          ),
        ),
      ],
    );
  }

  // Bottom bar
  Widget _buildBottomBar(BuildContext context, double total) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _showCheckoutDialog(context, total);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.bitcoinOrange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Passer commande',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialogs
  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider le panier'),
        content: const Text('Êtes-vous sûr de vouloir vider votre panier ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif de votre commande :'),
            const SizedBox(height: 16),
            ...(_cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '\$${(item.basePrice * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ))),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bitcoinOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Traiter la commande
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Commande passée avec succès ! 🎉'),
                  backgroundColor: AppColors.success,
                ),
              );
              setState(() {
                _cartItems.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Modèle CartItem
// ==========================================

class CartItem {
  final String id;
  final String name;
  final String shopName;
  final double basePrice;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.shopName,
    required this.basePrice,
    required this.quantity,
    required this.imageUrl,
  });
}