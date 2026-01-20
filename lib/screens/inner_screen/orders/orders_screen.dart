import 'package:flutter/material.dart';
import 'package:parfimerija_app/screens/inner_screen/orders/orders_widget.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/title_text.dart';


class OrdersScreen extends StatefulWidget {
  static const routName = '/OrderScreen';
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitelesTextWidget(label: 'Placed orders')),
      body: isEmptyOrders
          ? EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "No orders has been placed yet",
              subtitle: "",
              buttonText: "Shop now",
            )
          : ListView.separated(
              itemCount: 8,
              itemBuilder: (ctx, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidget(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  // thickness: 8,
                  // color: Colors.red,
                );
              },
            ),
    );
  }
}
