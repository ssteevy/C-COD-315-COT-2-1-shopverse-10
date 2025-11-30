import 'package:flutter/material.dart';

class MapGpsButton extends StatelessWidget {
  const MapGpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: const Icon(Icons.my_location, color: Colors.orange),
    );
  }
}
