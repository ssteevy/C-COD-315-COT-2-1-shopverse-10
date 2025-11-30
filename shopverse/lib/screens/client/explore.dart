
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/map_search_bar.dart';
import '../../widgets/map_gps_button.dart';
import '../../widgets/shop_bottom_sheet.dart';
import '../../models/shop.dart';


class ClientExplorePage extends StatefulWidget {
  const ClientExplorePage({super.key});

  @override
  State<ClientExplorePage> createState() => _ClientExplorePageState();
}

class _ClientExplorePageState extends State<ClientExplorePage> {
  GoogleMapController? mapController;

  final LatLng initialPosition = const LatLng(48.8566, 2.3522); // Position par défaut

  void onMapCreated(controller) {
    mapController = controller;
  }

  @override
  
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // ------------------------- CARTE -------------------------
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 4.5,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: {}, // tu vas ajouter les pins plus tard
          ),

          // ------------------------- BARRE DE RECHERCHE -------------------------
          const Positioned(
            top: 50,
            left: 20,
            right: 70,
            child: MapSearchBar(),
          ),

          // ------------------------- BOUTON GPS -------------------------
          const Positioned(
            top: 50,
            right: 20,
            child: MapGpsButton(),
          ),

          // ------------------------- BOTTOM SHEET -------------------------
          const Align(
            alignment: Alignment.bottomCenter,
            child: ShopBottomSheet(),
          ),
        ],
      ),
    );
  }
}
