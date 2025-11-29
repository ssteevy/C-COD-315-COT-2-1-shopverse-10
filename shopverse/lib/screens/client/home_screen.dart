import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Localisation
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 28,
                    ),

                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Calavi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "Bénin",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Ionicons.notifications_outline),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Ionicons.person_circle_outline),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // card btc price
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(.1),
                borderRadius: BorderRadius.circular(16),
                
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "\$45",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("220,77", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        "+2.23%",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.currency_bitcoin,
                        color: Colors.orange,
                        size: 38,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un produit, une boutique…",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // categories 
                      Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Catégories",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: const Text("Voir tout"))
              ],
            ),

            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _categoryCard("Électronique", Icons.devices),
                  _categoryCard("Mode", Icons.checkroom),
                  _categoryCard("Maison", Icons.chair),
                  _categoryCard("Beauté", Icons.face),
                  _categoryCard("Aliments", Icons.local_grocery_store),
                ],
              ),
            ),

            const SizedBox(height: 25),


            // 🔥 GRAPH CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Tendance 24h",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Le Bitcoin est en baisse 📉",
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 12),
                  Icon(Icons.show_chart, color: Colors.red, size: 80),
                ],
              ),
            ),
            const SizedBox(height: 30),

            //  BOUTIQUES À LA UNE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Boutiques à la Une",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text("Voir tout", style: TextStyle(color: Colors.orange)),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  boutiqueCard(
                    "Tech Store Paris",
                    "4.8 ★  •  2.3 km",
                    Colors.purple,
                  ),
                  boutiqueCard(
                    "Mode & Style",
                    "4.5 ★  •  4.8 km",
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET CARD BOUTIQUE
Widget boutiqueCard(
  String title,
  String subtitle,
  Color badgeColor,
) {
  return Container(
    width: 180,
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Populaire",
            style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
      ],
    ),
  );
}
  // widget categories 
  Widget _categoryCard(String title, IconData icon) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange.withOpacity(.1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
        ],
      ),
    );
  }
