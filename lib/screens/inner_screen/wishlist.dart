import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:parfimerija_app/providers/wishlist_provider.dart'; 
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/title_text.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    
    final wishListProducts = wishlistProvider.getWishlistItems.values.toList();


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
        title: TitelesTextWidget(label: "Wishlist (${wishListProducts.length})"),
        actions: [
          IconButton(
            onPressed: () {
              
              wishlistProvider.clearLocalWishlist();
            },
            icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
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
            return ProductWidget(product: product); 
          },
          itemCount: wishListProducts.length,
          crossAxisCount: 2,
        ),
      ),
    );
  }
}