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

    
    final orders = [
      {"id": "001", "user": "Marko Marković", "total": "4500 RSD", "status": "Pending"},
      {"id": "002", "user": "Jelena Janković", "total": "3200 RSD", "status": "Completed"},
      {"id": "003", "user": "Nikola Petrović", "total": "2700 RSD", "status": "Cancelled"},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Orders Management"),
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
                  "Add Order",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

        
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: orders.length,
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      "Order #${order["id"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                      ),
                    ),
                    subtitle: Text(
                      "${order["user"]} • ${order["total"]} • ${order["status"]}",
                      style: TextStyle(
                        color: isDark 
                            ? AppColors.chocolateDark.withValues(alpha:0.7) 
                            : AppColors.softAmber.withValues(alpha:0.7),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditOrderScreen(
                            id: order["id"]!,
                            user: order["user"]!,
                            total: order["total"]!,
                            status: order["status"]!,
                          ),
                        ),
                      );
                    },
                  ),
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
