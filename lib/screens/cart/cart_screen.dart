import 'package:flutter/material.dart';
import 'package:parfimerija_app/screens/cart/bottom_chechkout.dart';
import 'package:parfimerija_app/screens/cart/card_widget.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false; //false jer hocu da vidim i ekran koji kreiram

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            //ovo isEmpty? ako je prazan prikazi
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Your Cart is Empty",
              subtitle:
                  "Looks like you haven't added \n anything to your cart yet.",
              buttonText: "Shop Now",
            ),
          )
        : Scaffold(
          bottomSheet: const CartBottomSheetWeidget(),
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
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return CardWidget();
              },
            ),
          );
  }
}
