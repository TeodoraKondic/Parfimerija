/*import 'package:cloud_firestore/cloud_firestore.dart';
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
}*/





/*
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const TitelesTextWidget(label: 'Sve Porudžbine'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Povlačimo SVE dokumente iz kolekcije 'porudzbine'
        // Koristimo 'orderDate' za sortiranje (proveri da li se tako zove polje u bazi)
        stream: FirebaseFirestore.instance
            .collection('porudzbine')
            //.orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("DEBUG: Broj dokumenata u bazi: ${snapshot.data!.docs.length}");
          }
          if (snapshot.hasError) {
            print("DEBUG: Greška iz Firebase-a: ${snapshot.error}");
          }
          // 1. Provera učitavanja
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Provera greške (npr. ako nisi podesio Index u Firebase-u)
          if (snapshot.hasError) {
            return Center(
              child: SelectableText("Greška: ${snapshot.error}"),
            );
          }

          // 3. Provera da li je lista prazna
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Nema porudžbina",
              subtitle: "Trenutno ne postoji nijedna porudžbina u bazi.",
              buttonText: "Nazad",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }

          // 4. Prikaz liste ako podaci postoje
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 1, indent: 15, endIndent: 15);
            },
            itemBuilder: (ctx, index) {
              // Uzimamo podatke iz svakog dokumenta
              final orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

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
}*/


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
    // Uzimamo ulogovanog korisnika iz UserProvider-a
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUser;

    // Ako korisnik nije ulogovan
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const TitelesTextWidget(label: 'Sve Porudžbine'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Morate biti ulogovani da biste videli porudžbine."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitelesTextWidget(label: 'Sve Porudžbine'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Povlačimo samo porudžbine za ulogovanog korisnika
        stream: FirebaseFirestore.instance
            .collection('porudzbine')
            .where('uid', isEqualTo: user.uid)
            //.orderBy('orderDate', descending: true) // po potrebi
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("DEBUG: Broj dokumenata u bazi: ${snapshot.data!.docs.length}");
          }
          if (snapshot.hasError) {
            print("DEBUG: Greška iz Firebase-a: ${snapshot.error}");
          }

          // 1. Provera učitavanja
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Provera greške
          if (snapshot.hasError) {
            return Center(
              child: SelectableText("Greška: ${snapshot.error}"),
            );
          }

          // 3. Provera da li je lista prazna
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Nema porudžbina",
              subtitle: "Trenutno ne postoji nijedna porudžbina u bazi.",
              buttonText: "Nazad",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }

          // 4. Prikaz liste ako podaci postoje
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 1, indent: 15, endIndent: 15);
            },
            itemBuilder: (ctx, index) {
              // Uzimamo podatke iz svakog dokumenta
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
