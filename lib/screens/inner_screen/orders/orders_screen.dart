import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:parfimerija_app/screens/inner_screen/orders/orders_widget.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = '/OrderScreen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUser;


    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const TitelesTextWidget(label: 'All orders'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("You must be logged in to view orders."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitelesTextWidget(label: 'All orders'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
      
        stream: FirebaseFirestore.instance
            .collection('porudzbine')
            .where('uid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ignore: avoid_print
            print("DEBUG: Broj dokumenata u bazi: ${snapshot.data!.docs.length}");
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print("DEBUG: Greška iz Firebase-a: ${snapshot.error}");
          }

       
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: SelectableText("Error: ${snapshot.error}"),
            );
          }

        
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "No orders",
              subtitle: "There are currently no orders in the database.",
              buttonText: "Back",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }

        
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 1, indent: 15, endIndent: 15);
            },
            itemBuilder: (ctx, index) {
            
              final orderData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: OrdersWidget(orderData: orderData),
              );
            },
          );
        },
      ),
    );
  }
}
