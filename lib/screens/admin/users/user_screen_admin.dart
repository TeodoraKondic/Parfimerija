import 'package:cloud_firestore/cloud_firestore.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("User Management"),
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
                    MaterialPageRoute(
                        builder: (_) => const AddUserScreen()),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "Add User",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

         
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('korisnici')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No users in database."),
                  );
                }

                final usersDocs = snapshot.data!.docs;

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: usersDocs.length,
                  // ignore: unnecessary_underscores
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = usersDocs[index].data()
                        as Map<String, dynamic>;

                    final String id = usersDocs[index].id;
                    final String name = data['name'] ?? '';
                    final String surname = data['surname'] ?? '';
                    final String email = data['email'] ?? '';
                    final String phone =
                        data['phoneNumber'] ?? '';

                    final fullName = "$name $surname";

                    return Card(
                      color: isDark
                          ? AppColors.softAmber
                          : AppColors.chocolateDark,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4),
                        title: Text(
                          fullName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.chocolateDark
                                : AppColors.softAmber,
                          ),
                        ),
                        subtitle: Text(
                          "$email • $phone",
                          style: TextStyle(
                            color: (isDark
                                    ? AppColors.chocolateDark
                                    : AppColors.softAmber)
                                .withAlpha(180),
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
                              builder: (_) => EditUserScreen(
                                id: id,
                                name: name,
                                email: email,
                                phone: phone,
                              ),
                            ),
                          );
                        },
                      ),
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
