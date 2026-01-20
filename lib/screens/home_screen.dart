import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart'; // Importuj onaj ekran od malopre
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/circle.dart';
import 'package:parfimerija_app/widgets/map_widget.dart';
import 'package:parfimerija_app/widgets/products/CategoryListWidget.dart';

import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Lista test podataka za početnu stranu
    final List<Map<String, String>> popularPerfumes = [
      {
        "title": "Chanel No. 5",
        "brand": "Chanel",
        "price": "15.000",
        "image":
            "https://www.domusweb.it/content/dam/domusweb/en/speciali/assoluti-del-design/gallery/2024/boccette-di-profumo-diventate-unicona-da-dal-a-gehry/1-domus-profumi-chanel111.jpg.foto.rbig.jpg",
        "desc": "A timeless classic with floral notes.",
      },
      {
        "title": "Sauvage",
        "brand": "Dior",
        "price": "12.500",
        "image": "https://www.scentgod.com.au/img/perfumes/sauvage-edp.jpg",
        "desc": "Fresh scent.",
      },

      {
        "title": "Black Opium",
        "brand": "Yves Saint Laurent",
        "price": "11.000",
        "image":
            "https://jasmin.b-cdn.net/media/catalog/product/2/0/200302000139.jpg",
        "desc": "A glam rock fragrance full of mystery and energy.",
      },
      {
        "title": "Baccarat Rouge 540",
        "brand": "Maison Francis Kurkdjian",
        "price": "32.000",
        "image":
            "https://metropoliten.rs/upload/catalog/variation/8206/thumb/26955_1_694be90a993c1_980x980r.jpg",
        "desc": "Luminous and sophisticated woody floral scent.",
      },
      {
        "title": "Eros",
        "brand": "Versace",
        "price": "8.500",
        "image":
            "https://jasmin.b-cdn.net/media/catalog/product/cache/4456161891bc26600241f10587ca424f/v/e/versace.jpg",
        "desc": "Love, passion, beauty, and desire.",
      },
      {
        "title": "Light Blue",
        "brand": "Dolce & Gabbana",
        "price": "9.000",
        "image": "https://pafos.rs/img/products/3423473020264.jpg",
        "desc": "Stunning and overwhelming like the joy of living.",
      },
    ];
    final List<Map<String, String>> categories = [
      {
        "image": "${AssetsManager.imagePath}/categories/floral.png",
        "name": "Floral",
      },
      {
        "image": "${AssetsManager.imagePath}/categories/vanilla.png",
        "name": "Sweet",
      },
      {
        "image": "${AssetsManager.imagePath}/categories/woody.png",
        "name": "Woody",
      },
      {
        "image": "${AssetsManager.imagePath}/categories/citrus.png",
        "name": "Citrus",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const TitelesTextWidget(label: "Parfimerija"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.asset(
              "${AssetsManager.imagePath}/logo.png",
              fit: BoxFit
                  .cover, // Ovo osigurava da slika popuni krug bez rastezanja
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.getIsDarkTheme ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.setDarkTheme(
                themeValue: !themeProvider.getIsDarkTheme,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Kategorije ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TitelesTextWidget(
                label: "Categories",
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryRoundedWidget(
                    image: category['image']!,
                    name: category['name']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TitelesTextWidget(
                label: "Best-selling perfumes",

                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            // Horizontalna lista najpopularnijih
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularPerfumes.length,
                itemBuilder: (context, index) {
                  final perfume = popularPerfumes[index];
                  return GestureDetector(
                    onTap: () {
                      // NAVIGACIJA NA DETALJE
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            title: perfume['title']!,
                            brand: perfume['brand']!,
                            price: perfume['price']!,
                            image: perfume['image']!,
                            description: perfume['desc']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              perfume['image']!,
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SubtitleTextWidget(
                            label: perfume['title']!,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                          Text(
                            "${perfume['price']} RSD",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color, // Prati temu
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCircleWidget(
                  endValue: 12000,
                  suffix: "+",
                  label: "Satisfied\ncustomers",
                  color:
                      Theme.of(context).textTheme.titleLarge?.color ??
                      AppColors
                          .chocolateDark, //mora ?? AppColors.chocolateDark jer je colorsafty
                ),
                StatCircleWidget(
                  endValue: 8500,
                  label: "Perfumes\nsold",
                  color:
                      Theme.of(context).textTheme.titleLarge?.color ??
                      AppColors.chocolateDark,
                ),
              ],
            ),

            const SizedBox(height: 32),

            const SizedBox(height: 24),

            // NASLOV
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitelesTextWidget(
                label: "Find Us",
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            const SizedBox(height: 24),

            // DODAJ OVDE
            const MapWidget(),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SubtitleTextWidget(
                label: "Appearance settings:",
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SwitchListTile(
              title: Text(
                themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              value: themeProvider.getIsDarkTheme,
              onChanged: (value) =>
                  themeProvider.setDarkTheme(themeValue: value),
            ),
          ],
        ),
      ),
    );
  }
}
