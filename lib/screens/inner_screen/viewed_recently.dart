import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/viewed_provider.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/product/product_widgets.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});

 // final bool isEmpty = false; // promeni u true ako nema proizvoda

  @override
  Widget build(BuildContext context) {
     final viewedProducts = Provider.of<ViewedProvider>(context).items;

    if (viewedProducts.isEmpty) {
      return Scaffold(
        body: EmptyBagWidget(
          imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
          title: "No viewed products yet",
          subtitle: "Looks like you haven't viewed any products.",
          buttonText: "Shop now",
          onPressed: () {},
        ),
      );
    }

    /*return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "No viewed products yet",
              subtitle: "Looks like your cart is empty.",
              buttonText: "Shop now", onPressed: () {  },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "${AssetsManager.imagePath}/bag/checkout.png",
                ),
              ),
              title: const TitelesTextWidget(label: "Viewed recently"),
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
                itemCount: 20, // broj proizvoda koje želiš da prikažeš
                crossAxisCount: 2,
              ),
            ),
          );
  }*/
      return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("${AssetsManager.imagePath}/bag/checkout.png"),
        ),
        title: const TitelesTextWidget(label: "Viewed recently"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ViewedProvider>(context, listen: false).clear();
            },
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
            final product = viewedProducts[index];
            return ProductWidget(product: product);
          },
          itemCount: viewedProducts.length,
          crossAxisCount: 2,
        ),
      ),
    );
  }

}

