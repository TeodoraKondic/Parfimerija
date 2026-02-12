import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  Widget build(BuildContext context) {
    // Uzimamo ID trenutno ulogovanog korisnika
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const TitelesTextWidget(label: 'My Orders'),
      ),
      // Ako korisnik nije ulogovan (za svaki slučaj)
      body: currentUserId.isEmpty
          ? EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Please login to see your orders",
              subtitle: "",
              buttonText: "Login",
              onPressed: () {
              
              },
            )
          : StreamBuilder<QuerySnapshot>(
              
              stream: FirebaseFirestore.instance
                  .collection('porudzbine')
                  .where('uid', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
             
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

               
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return EmptyBagWidget(
                    imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
                    title: "No orders placed yet",
                    subtitle: "Looks like you haven't bought anything yet.",
                    buttonText: "Shop now",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                }
           
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(thickness: 1);
                  },
                  itemBuilder: (ctx, index) {
                  
                    final orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                      
                      child: OrdersWidget(orderData: orderData),
                    );
                  },
                );
              },
            ),
    );
  }
}