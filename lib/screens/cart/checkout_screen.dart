import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  static const routName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TitelesTextWidget(label: "Order Summary"),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDark
                          ? AppColors.chocolateDark
                          : AppColors.softAmber,
                      child: const Icon(Icons.shopping_bag),
                    ),
                    title: SubtitleTextWidget(label: product.name),
                    trailing: SubtitleTextWidget(
                      label: "${product.price * product.quantity} RSD",
                    ),
                  );
                },
                /*itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                    child: const Icon(Icons.shopping_bag),
                  ),
                  title: SubtitleTextWidget(label: "Product $index"),
                  trailing: SubtitleTextWidget(label: "${1200 * (index + 1)} RSD"),
                ),*/
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitelesTextWidget(label: "Total"),
                TitelesTextWidget(label: "6000 RSD"),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.chocolateDark
                    : AppColors.softAmber,
                foregroundColor: isDark
                    ? AppColors.softAmber
                    : AppColors.chocolateDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Dodao sam malo zaobljenja radi estetike
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Checkout successful!")),
                );
              },
              child: const Text(
                "Place Order",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
