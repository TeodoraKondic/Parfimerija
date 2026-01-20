import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';

class CheckoutScreen extends StatelessWidget {
  static const routName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // za temu dark/light
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TitelesTextWidget(label: "Order Summary"),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // primer za 5 proizvoda
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                    child: const Icon(Icons.shopping_bag),
                  ),
                  title: SubtitleTextWidget(label: "Product $index"),
                  trailing: SubtitleTextWidget(label: "${1200 * (index + 1)} RSD"),
                ),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                  foregroundColor: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // ovde možeš dodati backend checkout ili snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Checkout successful!")),
                  );
                },
                child: const Text("Place Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
