import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/orders/order_screen_admin.dart';
//import 'package:parfimerija_app/screens/admin/admin_tile.dart';
import 'package:parfimerija_app/screens/admin/perfume_management_screen.dart';
import 'package:parfimerija_app/screens/admin/review/review_screen_admin.dart';
import 'package:parfimerija_app/screens/admin/users/user_screen_admin.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const TitelesTextWidget(label: "Admin dashboard"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.setDarkTheme(
                themeValue: !isDark,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            _adminOption(
              context,
              icon: Icons.local_florist,
              title: "Perfume management",
              subtitle: "Add, edit or delete perfumes",
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfumeManagementScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            
            _adminOption(
              context,
              icon: Icons.people,
              title: "User management",
              subtitle: "Add, edit or delete users",
              isDark: isDark,
              onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserManagementScreen()),
                  );
              },
            ),
            const SizedBox(height: 12),

            
            _adminOption(
              context,
              icon: Icons.shopping_bag,
              title: "Orders management",
              subtitle: "Add, edit or delete orders",
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderManagementScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            
            _adminOption(
              context,
              icon: Icons.rate_review,
              title: "Reviews management",
              subtitle: "Edit or delete reviews",
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReviewScreenAdmin()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _adminOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Card(
      
      color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          
          color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            
            color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
           
            color: isDark 
              ? AppColors.chocolateDark.withValues(alpha: 0.7) 
              : AppColors.softAmber.withValues(alpha: 0.7),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        ),
      ),
    );
  }
}

