import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/review/add_rewiev_admin.dart';
import 'package:parfimerija_app/screens/admin/review/edit_review_admin.dart';
import 'package:provider/provider.dart';

class ReviewScreenAdmin extends StatelessWidget {
  const ReviewScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

   
    final reviews = [
      {"id": "101", "user": "Ana Petrović", "perfume": "Chanel No.5", "review": "Amazing scent, lasts long!", "rating": "10"},
      {"id": "102", "user": "Marko Jovanović", "perfume": "Sauvage", "review": "Fresh and powerful, love it.", "rating": "8"},
      {"id": "103", "user": "Jovana Lukić", "perfume": "Black Opium", "review": "Very sweet and elegant.", "rating": "9"},
    ];

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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReviewScreen()));
                },
                icon: const Icon(Icons.rate_review),
                label: const Text("Add Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),

        
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reviews.length,
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      "${review["perfume"]} (${review["rating"]}/10)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                      ),
                    ),
                    subtitle: Text(
                      "By: ${review["user"]}\n${review["review"]}",
                      style: TextStyle(
                        color: (isDark ? AppColors.chocolateDark : AppColors.softAmber).withValues(alpha:0.7),
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.chocolateDark : AppColors.softAmber),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditReviewScreen(
                            id: review["id"]!,
                            user: review["user"]!,
                            perfume: review["perfume"]!,
                            text: review["review"]!,
                            rating: review["rating"]!,
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
