import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/orders/add_order_admin.dart';
import 'package:parfimerija_app/screens/admin/orders/edit_order_admin.dart';
import 'package:provider/provider.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Orders Management (Admin)"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddOrderScreen()),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  "Add Order Manually",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('porudzbine')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "There are currently no orders in the database.",
                    ),
                  );
                }

                final ordersDocs = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ordersDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data =
                        ordersDocs[index].data() as Map<String, dynamic>;
                    final String id = data['orderId']?.toString() ?? 'N/A';
                    final String productName = data['productName'] ?? 'No Name';
                    final String total = "${data['priceTotal']} RSD";
                    final String status = data['status'] ?? 'pending';
                    final int quantity = data['quantity'] ?? 0;
                    final String uid = data['uid'] ?? '';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('korisnici')
                          .doc(uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        String userName = "Loading...";

                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            final userData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>;

                            userName =
                                userData['name'] ??
                                userData['fullName'] ??
                                userData['username'] ??
                                "Unknown User";
                          } else {
                            userName = "Unknown User";
                          }
                        }

                        return Card(
                          color: isDark
                              ? AppColors.softAmber
                              : AppColors.chocolateDark,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              "Order #$id",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.chocolateDark
                                    : AppColors.softAmber,
                              ),
                            ),
                            subtitle: Text(
                              "$productName (x$quantity) • $total • $status\nBy: $userName",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.chocolateDark.withAlpha(180)
                                    : AppColors.softAmber.withAlpha(180),
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: isDark
                                  ? AppColors.chocolateDark
                                  : AppColors.softAmber,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditOrderScreen(
                                    id: id,
                                    user: userName,
                                    total: total,
                                    status: status,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
