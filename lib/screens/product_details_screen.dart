import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/screens/admin/edit_perfume.dart';


class ProductDetailsScreen extends StatelessWidget {
  
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
    final dynamicColor = Theme.of(
      context,
    ).textTheme.titleLarge?.color; 
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Velika slika na vrhu koja se skuplja pri skrolovanju
          SliverAppBar(
            expandedHeight: 400,
            iconTheme: IconThemeData(color: dynamicColor),
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
                    style: TextStyle(
                      fontSize: 18,
                      
                      color: dynamicColor?.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$price RSD",
                    style: TextStyle(
                      fontSize: 22,
                      
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Description of the perfume:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 40),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chocolateDark,
                        foregroundColor: AppColors.softAmber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart!")),
                        );
                      },

                      icon: const Icon(Icons.shopping_bag),
                      label: const Text("Add to cart"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dugme za izmenu parfema (samo admin)
                  //if (currentUser == UserType.admin)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chocolateDark,
                        foregroundColor: AppColors.softAmber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // ignore: avoid_print
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPerfumeScreen(
                              title: title,
                              brand: brand,
                              price: price,
                              description: description,
                              image: image,
                            ),
                          ),
                        );
                        // ignore: avoid_print
                        print("Admin clicked Edit Perfume: $title");
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Perfume"),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
