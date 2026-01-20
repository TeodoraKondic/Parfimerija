import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/product/latest_arrival.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchSreenState();
}

class SearchSreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                "${AssetsManager.imagePath}/logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: const Text("Search screen"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Provider.of<ThemeProvider>(context).getIsDarkTheme
                            ? AppColors.chocolateDark
                            : AppColors.softAmber,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            searchTextController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),

                    Text(
                      "Latest Arrivals",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 330,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: latestArrivals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: LatestArrivalProductsWidget(index: index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50.0),

                    // 4. Most Popular
                    Text(
                      "Most Popular",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverDynamicHeightGridView(
                  itemCount: 5,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  builder: (context, index) {
                    return const ProductWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
