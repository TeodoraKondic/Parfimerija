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

 
    final Color cardColor = isDark ? AppColors.softAmber : AppColors.chocolateDark;
    final Color textColor = isDark ? AppColors.chocolateDark : AppColors.softAmber;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("User Management"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: () async {
                  final refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddUserScreen()),
                  );

                  if (refresh == true) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User added successfully!"),
                        ),//ovo mi je da se odmah prikze na ekranu da ne moram da izlazim iz app
                      );
                    }
                  }
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text(
                  "Add new user",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('korisnici')
                  .orderBy('name', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                final usersDocs = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: usersDocs.length,
                  // ignore: unnecessary_underscores
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = usersDocs[index].data() as Map<String, dynamic>;

                    final String id = usersDocs[index].id;
                    final String name = data['name'] ?? 'No Name';
                    final String email = data['email'] ?? 'No Email';
                    final String phoneNumber = data['phoneNumber'] ?? 'No Phone';
                    final String address = data['address'] ?? 'No Address';
                    final String imageUrl = data['userImage'] ?? '';

                    return Card(
                      color: cardColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          radius: 28,
                          // ignore: deprecated_member_use
                          backgroundColor: textColor.withOpacity(0.2),
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl.isEmpty
                              ? Icon(Icons.person, color: textColor, size: 30)
                              : null,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            // ignore: deprecated_member_use
                            Text(email, style: TextStyle(color: textColor.withOpacity(0.9))),
                            // ignore: deprecated_member_use
                            Text(phoneNumber, style: TextStyle(color: textColor.withOpacity(0.9))),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                // ignore: deprecated_member_use
                                Icon(Icons.location_on, size: 14, color: textColor.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      // ignore: deprecated_member_use
                                      color: textColor.withOpacity(0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.edit_note, color: textColor, size: 30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditUserScreen(
                                id: id,
                                name: name,
                                email: email,
                                phone: phoneNumber,
                                address:address, // Mapiramo phoneNumber na ono što EditUser očekuje
                                // Ako EditUserScreen podržava adresu, dodaj i: address: address,
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
        ],
      ),
    );
  }
}