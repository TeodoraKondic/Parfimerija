import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  // Funkcija za otvaranje navigacije
  Future<void> _openMap() async {
    // Koordinate tvoje parfimerije (primer za Novi Sad)
    const double lat = 45.2671; 
    const double lng = 19.8335;
    final Uri url = Uri.parse('google.navigation:q=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Ako ne može direktno navigacija, otvori u pretraživaču
      await launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Our Location",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(45.2671, 19.8335),
                    zoom: 14,
                  ),
                  markers: {
                    const Marker(
                      markerId: MarkerId('radnja'),
                      position: LatLng(45.2671, 19.8335),
                      infoWindow: InfoWindow(title: "Parfimerija"),
                    ),
                  },
                ),
              ),
              // Dugme za navigaciju u uglu mape
              Positioned(
                bottom: 12,
                right: 12,
                child: FloatingActionButton.extended(
                  onPressed: _openMap,
                  foregroundColor:AppColors.softAmber,//ovo je za boju slova na dugmetu za dircetions
                  backgroundColor: AppColors.chocolateDark,
                  label: const Text("Get Directions"),
                  icon: const Icon(Icons.directions),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
KLJUC 
AIzaSyAfLpcuwMP4S5M2z8vaIDYU93ex0kLzScU

 */