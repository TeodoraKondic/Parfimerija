//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';

class QuantityBottomSheetWidget extends StatefulWidget {
  final Product product;
  final CartProvider cartProvider;

  const QuantityBottomSheetWidget({
    super.key,
    required this.product,
    required this.cartProvider,
  });

  @override
  State<QuantityBottomSheetWidget> createState() => _QuantityBottomSheetWidgetState();
}

class _QuantityBottomSheetWidgetState extends State<QuantityBottomSheetWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: 25,
            itemBuilder: (context, index) {
              final value = index + 1;
              return InkWell(
                onTap: () {
                  setState(() {
                    quantity = value;
                  });
                  // update product in cart
                  widget.cartProvider.updateQuantity(widget.product, quantity);
                  Navigator.pop(context); // zatvori sheet
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SubtitleTextWidget(label: "$value"),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}