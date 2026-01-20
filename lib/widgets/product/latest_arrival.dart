import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:parfimerija_app/const/app_colors.dart';
//import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/widgets/product/heart_btn.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

final List<Map<String, String>> latestArrivals = [
  {
    "title": "Dior J'adore",
    "brand": "Dior",
    "price": "18.500",
    "image":
        "https://img.lojasrenner.com.br/item/500891161/zoom/11.jpg",
  },
  {
    "title": "Mugler Angel",
    "brand": "Mugler",
    "price": "14.000",
    "image":
        "https://cdn.tiramisuerp.com/s3.drogerija.me/972935_3529820.jpg",
  },
  {
    "title": "Elizabeth Arden Believe",
    "brand": "Elizabeth Arden",
    "price": "9.500",
    "image":
        "https://www.yourpharmacy.ie/cdn/shop/files/PER0245_1.png?v=1761826235&width=2048",

  },
  {
    "title": "Marc Jacobs Daisy",
    "brand": "Marc Jacobs",
    "price": "16.000",
    "image":
        "https://the-fragrance-shop.imgix.net/products/10968--new--.jpg?fm=webp",

  },
  {
    "title": "Gucci Bloom",
    "brand": "Gucci",
    "price": "19.000",
    "image":
        "https://www.perfumestudiomnl.com/cdn/shop/files/image_28839bf4-767f-4aa8-9f36-0523330842d3.png?v=1686755674&width=1946",
  },
];

/*class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // TODO: Navigacija na detalje proizvoda
      },
      child: Container(
        width: size.width * 0.45, // širina za horizontalni scroll
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).getIsDarkTheme
              ? AppColors.chocolateDark
              : AppColors.softAmber,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Slika proizvoda ---
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: FancyShimmerImage(
                imageUrl: AppConstants.imageUrl,
                width: double.infinity,
                height: size.width * 0.3,
                boxFit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 6),
            // --- Naslov proizvoda ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: TitelesTextWidget(
                label: "Parfume " * 1,
                fontSize: 16,
                maxLines: 1,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            // --- Cena i HeartButton ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubtitleTextWidget(
                    label: "1200 RSD",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  HeartButtonWidget(size: 22, bkgColor: Colors.transparent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

class LatestArrivalProductsWidget extends StatelessWidget {
  final int index;
  const LatestArrivalProductsWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final product = latestArrivals[index];
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // TODO: navigacija na detalje proizvoda
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
            // ---------- IMAGE ----------
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: FancyShimmerImage(
                imageUrl: product["image"]!,
                width: double.infinity,
                height: size.width * 0.6,//ovde povecavs sliku
                boxFit: BoxFit.cover,
              ),
            ),

            // ---------- TEXT + PRICE + HEART ----------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // naziv parfema
                  TitelesTextWidget(
                    label: product["title"]!,
                    fontSize: 15,
                    maxLines: 1,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),

                  const SizedBox(height: 6),

                  // cena + srce
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubtitleTextWidget(
                        label: "${product["price"]} RSD",
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      HeartButtonWidget(
                        size: 22,
                        bkgColor: Colors.transparent,
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

