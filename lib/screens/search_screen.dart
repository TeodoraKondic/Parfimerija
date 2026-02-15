import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/services/product_service.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/product/latest_arrival.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  List<Product> latestArrivals = [];
  List<Product> mostPopular = [];
  List<Product> filteredMostPopular = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
    loadProducts();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      final allProducts = await ProductService().getProducts();

      setState(() {
       
        latestArrivals = allProducts.reversed.take(6).toList();

        mostPopular = allProducts.toList();

        filteredMostPopular = List.from(mostPopular);

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products: $e")),
      );
    }
  }

  void filterProducts(String query) {
    final lowerQuery = query.toLowerCase().trim();

    setState(() {
      filteredMostPopular = mostPopular
          .where((p) => p.name.toLowerCase().contains(lowerQuery))
          .toList();
    });
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                          TextField(
                            controller: searchTextController,
                            onChanged: (value) {
                              filterProducts(value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Provider.of<ThemeProvider>(context).getIsDarkTheme
                                  ? AppColors.chocolateDark
                                  : AppColors.softAmber,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  searchTextController.clear();
                                  filterProducts(""); 
                                  FocusScope.of(context).unfocus();
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
                            child: latestArrivals.isEmpty
                                ? const Center(child: Text("No products available"))
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: latestArrivals.length,
                                    itemBuilder: (context, index) {
                                      final product = latestArrivals[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: LatestArrivalProductsWidget(product: product),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 50.0),

                  
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
                        itemCount: filteredMostPopular.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        builder: (context, index) {
                          final product = filteredMostPopular[index];
                          return ProductWidget(product: product);
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
