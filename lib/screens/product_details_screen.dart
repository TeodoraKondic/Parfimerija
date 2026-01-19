import 'package:flutter/material.dart';

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
                  Text(brand, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("$price RSD", style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("Description of the perfume:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 40),
                  
                  // Dugme za korpu (bitno za funkcionalnost CP2)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
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