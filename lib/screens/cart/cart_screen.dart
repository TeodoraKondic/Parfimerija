import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/screens/cart/bottom_chechkout.dart';
import 'package:parfimerija_app/screens/cart/card_widget.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Your Cart is Empty",
              subtitle: "Looks like you haven't added \n anything to your cart yet.",
              buttonText: "Shop Now",
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/search");
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "${AssetsManager.imagePath}/bag/checkout.png",
                ),
              ),
              title: const Text("Your cart"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  /*child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const CardWidget();
                    },
                  ),*/
                   child: Builder(
    builder: (context) {
      final cart = Provider.of<CartProvider>(context); // uzimamo korpu

      return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final product = cart.items[index];
          return CardWidget(product: product); // prosledjujemo proizvod
        },
      );
    },
  ),
                ),
                
                Container(
                  decoration: BoxDecoration(
                    
                    color: Theme.of(context).cardColor.withValues(alpha:0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black..withValues(alpha:0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: const CartBottomSheetWeidget(),
                ),
              ],
            ),
          );
  }
}
