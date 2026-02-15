import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/models/product.dart';
//import 'package:parfimerija_app/providers/products_provider.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart';
import 'package:parfimerija_app/widgets/product/heart_btn.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';


class LatestArrivalProductsWidget extends StatelessWidget {
  /*final int index;*/
  final Product product;
  const LatestArrivalProductsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //final product = latestArrivals[index];
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              title: product.name,
              brand: product.brand,
              price: product.price.toString(),
              image: product.imageUrl,
              description: product.description, //?? "No description available",
            ),
          ),
        );
      },
      child: Container(
        width: size.width * 0.45,
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).getIsDarkTheme
              ? AppColors.chocolateDark
              : AppColors.softAmber,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: FancyShimmerImage(
                imageUrl: product.imageUrl,
                width: double.infinity,
                height: size.width * 0.45, //ovde povecavm sliku
                boxFit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelesTextWidget(
                    label: product.name,
                    fontSize: 15,
                    maxLines: 1,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),

                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubtitleTextWidget(
                        label: "${product.price} RSD",
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),

                      Provider<Product>.value(
                        value: product,
                        child: const HeartButtonWidget(
                          size: 20,
                          bkgColor: Colors.transparent,
                        ),
                      ),
                    ],
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
