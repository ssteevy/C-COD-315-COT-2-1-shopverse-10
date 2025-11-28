
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) return SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Photo de profil
            CircleAvatar(
              radius: 50,
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl!)
                  : null,
              child: user.photoUrl == null
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 16),

            // Nom
            Text(
              user.displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),

            // Badge rôle
            Chip(
              label: Text(
                user.role == UserRole.client ? 'Client' : 'Commerçant',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: user.role == UserRole.client
                  ? Color(0xFF1E3A8A)
                  : Color(0xFFF7931A),
            ),
            SizedBox(height: 32),

            // Section devenir commerçant
            _MerchantRequestSection(user: user),

            SizedBox(height: 24),

            // Options du profil
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modifier mon profil'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigation vers écran d'édition
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historique des achats'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigation vers historique
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Mes favoris'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // Navigation vers favoris
              },
            ),
            Divider(height: 32),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await authProvider.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// demande commercant 
class _MerchantRequestSection extends StatefulWidget {
  final UserModel user;

  const _MerchantRequestSection({required this.user});

  @override
  State<_MerchantRequestSection> createState() => _MerchantRequestSectionState();
}

class _MerchantRequestSectionState extends State<_MerchantRequestSection> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Devenir Commerçant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expliquez-nous pourquoi vous souhaitez devenir commerçant sur ShopVerse :',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Je souhaite vendre...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez indiquer une raison')),
                );
                return;
              }

              final authProvider = context.read<AuthProvider>();
              final success = await authProvider.requestMerchantStatus(
                _reasonController.text.trim(),
              );

              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Demande envoyée avec succès !'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur lors de l\'envoi'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Déjà commerçant
    if (widget.user.role == UserRole.merchant) {
      return Card(
        color: Color(0xFFF7931A).withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFFF7931A)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Vous êtes commerçant',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Demande en attente
    if (widget.user.hasPendingMerchantRequest) {
      return Card(
        color: Color(0xFFF59E0B).withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.pending, color: Color(0xFFF59E0B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Demande en cours',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Votre demande pour devenir commerçant est en cours d\'examen par nos administrateurs.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      );
    }

    // Demande rejetée
    if (widget.user.merchantRequestStatus == MerchantRequestStatus.rejected) {
      return Card(
        color: Color(0xFFEF4444).withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cancel, color: Color(0xFFEF4444)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Demande refusée',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.user.rejectionReason != null) ...[
                SizedBox(height: 8),
                Text(
                  'Raison : ${widget.user.rejectionReason}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Peut faire une demande
    if (widget.user.canRequestMerchantStatus) {
      return Card(
        child: InkWell(
          onTap: _showRequestDialog,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.storefront,
                  color: Color(0xFFF7931A),
                  size: 32,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Devenir Commerçant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Vendez vos produits sur ShopVerse',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox();
  }
}