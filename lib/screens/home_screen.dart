import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/services/product_service.dart';
import 'package:parfimerija_app/widgets/circle.dart';
import 'package:parfimerija_app/widgets/map_widget.dart';
import 'package:parfimerija_app/widgets/products/category_list_widget.dart';

import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();
  List<Product> popularPerfumes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    popularPerfumes = await _service.getProducts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
                separatorBuilder: (_, _) => const SizedBox(width: 16),
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
            // lista najpopularnijih
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                //itemCount: popularPerfumes.length,
                itemCount: popularPerfumes.take(5).length,
                itemBuilder: (context, index) {
                  final perfume = popularPerfumes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            //id: perfume.id,
                            title: perfume.name,
                            brand: perfume.brand,
                            price: perfume.price
                                .toString(), // Mora u String jer detalji traže String
                            image: perfume.imageUrl,
                            description: perfume.description,
                          ),
                        ),
                      );
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            /*title: perfume['title']!,
                            brand: perfume['brand']!,
                            price: perfume['price']!,
                            image: perfume['image']!,
                            description: perfume['desc']!,*/
                            title: perfume.name,
                            brand: perfume.brand,
                            price: perfume.price.toString(),
                            image: perfume.imageUrl,
                            description: perfume.description,
                          ),
                        ),
                      );*/
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
                              //perfume['image']!,
                              perfume.imageUrl,
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SubtitleTextWidget(
                            //label: perfume['title']!,
                            label: perfume.name,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                          Text(
                            //"${perfume['price']} RSD",
                            "${perfume.price} RSD",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TitelesTextWidget(
                label: "Find Us",
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),

            const SizedBox(height: 24),

            const MapWidget(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
