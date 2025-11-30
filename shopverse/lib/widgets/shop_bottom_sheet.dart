import 'package:flutter/material.dart';

class ShopBottomSheet extends StatelessWidget {
  const ShopBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------- Favoris (étoile) -------
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 26),
            ),
          ),

          const SizedBox(height: 16),

          // ------- Titre -------
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "5 boutiques à proximité",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ------- Liste horizontale -------
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                shopCard("Tech Store Paris", "images/tech.jpg"),
                shopCard("Mode & Style", "images/mode.jpg"),
                shopCard("Bio Market", "images/bio.jpg"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shopCard(String title, String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
