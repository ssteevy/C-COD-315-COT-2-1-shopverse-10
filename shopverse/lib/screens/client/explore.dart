import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ClientExplorePage extends StatelessWidget {
  const ClientExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              // Basculer entre carte et liste
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte 
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Carte Google Maps',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'À intégrer avec google_maps_flutter',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Barre de recherche en haut
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher près de vous...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

