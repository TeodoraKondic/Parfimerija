import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/services/product_service.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/title_text.dart';

class WishlistScreen extends StatefulWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}
class _WishlistScreenState extends State<WishlistScreen> {
  //final bool isEmpty = false; // promeni u false ako ima proizvoda
  final ProductService _service = ProductService(); // servis koji dobija proizvode
  List<Product> wishListProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    wishListProducts = await _service.getProducts(); 
    // kasnije možeš filtrirati samo proizvode koji su u wishlisti
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
        if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (wishListProducts.isEmpty) {
      return Scaffold(
        body: EmptyBagWidget(
          imagePath: "${AssetsManager.imagePath}/bag/wishlist.png",
          title: "Nothing in your wishlist yet",
          subtitle: "Looks like your wishlist is empty.",
          buttonText: "Shop now",
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/search');
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("${AssetsManager.imagePath}/bag/wishlist.png"),
        ),
        title: const TitelesTextWidget(label: "Wishlist"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DynamicHeightGridView(
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          builder: (context, index) {
            final product = wishListProducts[index];
            return ProductWidget(product: product); // OBAVEZNO prosledi product
          },
          itemCount: wishListProducts.length,
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
    /*return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/wishlist.png",
              title: "Nothing in your wishlist yet",
              subtitle: "Looks like your wishlist is empty.",
              buttonText: "Shop now", onPressed: () { 
                Navigator.pushReplacementNamed(context, '/search');
                
                },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "${AssetsManager.imagePath}/bag/wishlist.png",
                ),
              ),
              title: const TitelesTextWidget(label: "Wishlist"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                builder: (context, index) {
                  return const ProductWidget(); 
                },
                itemCount: 6, // broj proizvoda u wish listi
                crossAxisCount: 2,
              ),
            ),
          );
  }*/

