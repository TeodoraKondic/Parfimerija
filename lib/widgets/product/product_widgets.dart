//import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
//import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart';
import 'package:parfimerija_app/widgets/product/heart_btn.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  const ProductWidget({super.key, required this.product});

  @override
  State<ProductWidget> createState() => ProductWidgetState();
}

class ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                title: product.name,
                brand: product.brand,
                price: product.price.toString(),
                image: product.imageUrl,
                description: product.description,
              ),
            ),
          );
          //log("ToDo add the navigate to the product details screen");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                //imageUrl: AppConstants.imageUrl,
                imageUrl: product.imageUrl,
                height: size.height * 0.22,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: TitelesTextWidget(
                      //label: "Perfume" * 1,
                      label: product.name,
                      fontSize: 18,
                      maxLines: 2,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  //Flexible(flex: 2, child: const HeartButtonWidget()),
                  Flexible(
                    flex: 2,
                    child: Provider<Product>.value(
                      value: product,
                      child: const HeartButtonWidget(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: SubtitleTextWidget(
                      //label: "1200 RSD",
                      label: "${product.price.toStringAsFixed(0)} RSD",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),

                      color: Provider.of<ThemeProvider>(context).getIsDarkTheme
                          ? AppColors.lightVanilla
                          : AppColors.chocolateDark,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () {
                          final cartProvider = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );

                          cartProvider.addProduct(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart!"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        splashColor:
                            Provider.of<ThemeProvider>(context).getIsDarkTheme
                            ? AppColors.chocolateDark
                            : AppColors.lightVanilla,

                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add_shopping_cart_outlined,
                            color:
                                Provider.of<ThemeProvider>(
                                  context,
                                ).getIsDarkTheme
                                ? AppColors.chocolateDark
                                : AppColors.lightVanilla,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
