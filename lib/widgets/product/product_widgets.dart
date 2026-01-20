import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/widgets/product/heart_btn.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key});

  @override
  State<ProductWidget> createState() => ProductWidgetState();
}

class ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          log("ToDo add the navigate to the product details screen");
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FancyShimmerImage(
                imageUrl: AppConstants.imageUrl,
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
                      label: "Parfume " * 1,
                      fontSize: 18,
                      maxLines: 2,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Flexible(flex: 2, child: const HeartButtonWidget()
                    
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
                      label: "1200 RSD",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  Flexible(
                    child: Material(
                      borderRadius: BorderRadius.circular(12.0),
                     
                      color: Provider.of<ThemeProvider>(context).getIsDarkTheme
                          ? AppColors
                                .lightVanilla 
                          : AppColors.chocolateDark,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: () {},
                        splashColor:
                            Provider.of<ThemeProvider>(context).getIsDarkTheme
                            ? AppColors
                                  .chocolateDark 
                            : AppColors.lightVanilla,
                        
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.add_shopping_cart_outlined,
                            color:
                                Provider.of<ThemeProvider>(
                                  context,
                                ).getIsDarkTheme
                                ? AppColors
                                      .chocolateDark 
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
