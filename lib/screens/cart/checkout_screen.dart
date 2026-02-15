import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const routName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  String _selectedPaymentMethod = "card"; 
  bool _isLoading = false;

  Future<void> _placeOrder({
    required BuildContext context,
    required CartProvider cartProvider,
    required String userId,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var product in cartProvider.items) {
        final orderRef = FirebaseFirestore.instance.collection('porudzbine').doc();

        batch.set(orderRef, {
          'orderId': orderRef.id,
          'paymentMethod': _selectedPaymentMethod, 
          'priceTotal': product.price * product.quantity,
          'productName': product.name,
          'quantity': product.quantity,
          'status': 'pending', 
          'uid': userId,
          'createdAt': Timestamp.now(),
        });
      }

      await batch.commit();
      cartProvider.clearCart();

      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order successfully placed!")),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitelesTextWidget(label: "Order summary"),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final product = cart.items[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: SubtitleTextWidget(label: product.name),
                        trailing: Text("${product.price * product.quantity} RSD"),
                      );
                    },
                  ),
                ),
                
                const Divider(thickness: 2),
                const SizedBox(height: 10),
                const TitelesTextWidget(label: "Payment method"),
                
         
                RadioListTile<String>(
                  title: const Text("Credit card"),
                  value: "card",
                  // ignore: deprecated_member_use
                  groupValue: _selectedPaymentMethod,
                  activeColor: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text("Cash on delivery"),
                  value: "cash",
                  // ignore: deprecated_member_use
                  groupValue: _selectedPaymentMethod,
                  activeColor: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  // ignore: deprecated_member_use
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
            

                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitelesTextWidget(label: "Total:"),
                    TitelesTextWidget(label: "${cart.totalPrice.toStringAsFixed(2)} RSD"),
                  ],
                ),
                const SizedBox(height: 20),
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
                backgroundColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                foregroundColor: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (cart.items.isEmpty || user == null || _isLoading)
                  ? null
                  : () async {
                      await _placeOrder(
                        context: context,
                        cartProvider: cart,
                        userId: user.uid,
                      );
                    },
              child: Text(
                user == null ? "Please Login" : "Place Order",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}