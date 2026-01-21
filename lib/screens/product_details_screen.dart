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
    final dynamicColor =
        Theme.of(context).textTheme.titleLarge?.color;

    // HARDKODOVANE RECENZIJE (simulacija)
    final reviews = [
      {
        "user": "Ana Petrović",
        "rating": "10",
        "text": "Amazing scent, lasts long!"
      },
      {
        "user": "Marko Jovanović",
        "rating": "8",
        "text": "Fresh and powerful, perfect for everyday use."
      },
      {
        "user": "Jovana Lukić",
        "rating": "9",
        "text": "Very elegant and sweet perfume."
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            iconTheme: IconThemeData(color: dynamicColor),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(image, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BRAND
                  Text(
                    brand,
                    style: TextStyle(
                      fontSize: 18,
                      color: dynamicColor?.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // TITLE
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // PRICE
                  Text(
                    "$price RSD",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DESCRIPTION
                  Text(
                    "Description of the perfume:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: dynamicColor,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ADD TO CART
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
                          const SnackBar(
                            content: Text("Added to cart!"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text("Add to cart"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EDIT PERFUME (ADMIN)
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditPerfumeScreen(
                              title: title,
                              brand: brand,
                              price: price,
                              description: description,
                              image: image,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Perfume"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // REVIEWS TITLE
                  Text(
                    "User reviews",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // REVIEWS LIST
                  reviews.isEmpty
                      ? Text(
                          "No reviews yet.",
                          style: TextStyle(color: dynamicColor),
                        )
                      : Column(
                          children: reviews.map((review) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.05),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review["user"]!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: dynamicColor,
                                        ),
                                      ),
                                      Text(
                                        "${review["rating"]}/10",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: dynamicColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review["text"]!,
                                    style: TextStyle(
                                      color: dynamicColor
                                          ?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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

