import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/users/add_user.dart';
import 'package:parfimerija_app/screens/admin/users/edit_user.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Uzimamo temu iz providera
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    // Hardkodovani korisnici
    final users = [
      {"name": "Marko Marković", "email": "marko@gmail.com", "phone": "061123456"},
      {"name": "Jelena Janković", "email": "jelena@gmail.com", "phone": "062987654"},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Column(
        children: [
          // DUGME ZA DODAVANJE NA VRHU
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
                    MaterialPageRoute(builder: (_) => const AddUserScreen()),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "Add User",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

          // LISTA KORISNIKA
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  // Logika boja: Kontrast pozadini ekrana
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      user["name"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                      ),
                    ),
                    subtitle: Text(
                      "${user["email"]} • ${user["phone"]}",
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
                          builder: (_) => EditUserScreen(
                            name: user["name"]!,
                            email: user["email"]!,
                            phone: user["phone"]!,
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
