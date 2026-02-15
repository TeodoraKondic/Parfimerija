import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/screens/admin/edit_perfume.dart';

import 'package:parfimerija_app/providers/viewed_provider.dart';
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dynamicColor = Theme.of(context).textTheme.titleLarge?.color;
    Provider.of<ViewedProvider>(context, listen: false).addItem(title);

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
                  Text(
                    brand,
                    style: TextStyle(
                      fontSize: 18,
                      color: dynamicColor?.withAlpha(180),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "$price RSD",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        if (!userProvider.isLoggedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("You do not have authorization for this action."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        final cartProvider =
                            Provider.of<CartProvider>(context, listen: false);

                        final productToAdd = Product(
                          id: DateTime.now().toString(),
                          name: title,
                          price: double.parse(price),
                          imageUrl: image,
                          brand: brand,
                          description: description,
                        );

                        cartProvider.addProduct(productToAdd);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$title added to cart!"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text("Add to cart"),
                    ),
                  ),
                  const SizedBox(height: 20),

                
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
                        if (!userProvider.isAdmin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("You do not have authorization for this action."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

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
                      label: const Text("Edit perfume"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "User reviews",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('recenzije')
                        .where('perfumeName', isEqualTo: title)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          "No reviews yet.",
                          style: TextStyle(color: dynamicColor),
                        );
                      }

                      final reviews = snapshot.data!.docs;

                      return Column(
                        children: reviews.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(13),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data["userName"] ?? "Unknown user",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: dynamicColor,
                                      ),
                                    ),
                                    Text(
                                      "${data["rating"]}/10",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: dynamicColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data["reviewText"] ?? "",
                                  style: TextStyle(
                                    color: dynamicColor?.withAlpha(200),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
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
