import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/title_text.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({super.key});

  final bool isEmpty = false; // promeni u false ako ima proizvoda

  @override
  Widget build(BuildContext context) {
    return isEmpty
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
  }
}
