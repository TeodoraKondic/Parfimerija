import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/review/add_rewiev_admin.dart';
import 'package:parfimerija_app/screens/admin/review/edit_review_admin.dart';
import 'package:provider/provider.dart';

class ReviewScreenAdmin extends StatelessWidget {
  const ReviewScreenAdmin({super.key});

  
  Future<String> _getUserName(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('korisnici').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return "${data?['name'] ?? ''} ${data?['surname'] ?? ''}";
    }
    return "Unknown user";
  }


  Future<String> _getPerfumeName(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('parfemi')
        .doc(productId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'] ?? 'Unknown perfume';
    }
    return "Unknown perfume";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Review Management"),
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
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddReviewScreen()),
                  );
                },
                icon: const Icon(Icons.rate_review),
                label: const Text(
                  "Add Review",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('recenzije').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reviews = snapshot.data!.docs;

                if (reviews.isEmpty) {
                  return const Center(child: Text("No reviews yet."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final data =
                        reviews[index].data() as Map<String, dynamic>;
                    final recId = reviews[index].id;

                    final uid = data['uid'] ?? '';
                    final productId = data['productId'] ?? '';
                    final comment = data['comment'] ?? '';
                    final rating = (data['rating'] ?? 0).toString();

                  
                    return FutureBuilder<List<String>>(
                      future: Future.wait([
                        _getUserName(uid),
                        _getPerfumeName(productId),
                      ]),
                      builder: (context, snapshot) {
                        String userName = "Loading...";
                        String perfumeName = "Loading...";

                        if (snapshot.hasData) {
                          userName = snapshot.data![0];
                          perfumeName = snapshot.data![1];
                        }

                        return Card(
                          color: isDark
                              ? AppColors.softAmber
                              : AppColors.chocolateDark,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(
                              "$perfumeName ($rating/10)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.chocolateDark
                                    : AppColors.softAmber,
                              ),
                            ),
                            subtitle: Text(
                              "By: $userName\n$comment",
                              style: TextStyle(
                                color: (isDark
                                        ? AppColors.chocolateDark
                                        : AppColors.softAmber)
                                    .withAlpha(180),
                              ),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: isDark
                                    ? AppColors.chocolateDark
                                    : AppColors.softAmber),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditReviewScreen(
                                    id: recId,
                                    user: userName,
                                    perfume: perfumeName,
                                    text: comment,
                                    rating: rating,
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



