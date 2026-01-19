import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  // Ovi podaci će biti prosleđeni kada klikneš na parfem
  final String title;
  final String brand;
  final String price;
  final String image;
  final String description;

  const ProductDetailsScreen({
    super.key,
    required this.title,
    required this.brand,
    required this.price,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Velika slika na vrhu koja se skuplja pri skrolovanju
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(image, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.chocolateDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chocolateDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$price RSD",
                    style: const TextStyle(
                      fontSize: 22,
                      color: AppColors.chocolateDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description of the perfume:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chocolateDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.chocolateDark,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Dugme za korpu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors
                            .chocolateDark, // Pozadina dugmeta (tvoja boja #7B3F00)
                        foregroundColor: AppColors
                            .softAmber, // Boja slova i ikonice (svetlo žuta)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Da ivice budu malo zaobljene
                        ),
                      ),
                      onPressed: () {
                        // Ovde ćeš u CP3 dodati logiku za korpu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart!")),
                        );
                      },

                      icon: const Icon(Icons.shopping_bag),
                      label: const Text("Add to cart"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
