import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/add_perfume.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class PerfumeManagementScreen extends StatelessWidget {
  const PerfumeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    final perfumes = [
      {
        "title": "Chanel No. 5",
        "brand": "Chanel",
        "price": "15000",
        "image":
            "https://www.domusweb.it/content/dam/domusweb/en/speciali/assoluti-del-design/gallery/2024/boccette-di-profumo-diventate-unicona-da-dal-a-gehry/1-domus-profumi-chanel111.jpg.foto.rbig.jpg",
        "desc": "A timeless classic with floral notes."
      },
      {
        "title": "Sauvage",
        "brand": "Dior",
        "price": "12500",
        "image": "https://www.scentgod.com.au/img/perfumes/sauvage-edp.jpg",
        "desc": "Fresh and powerful scent."
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Perfume management"),
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
                      builder: (_) => const AddPerfumeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add perfume",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          
          
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              itemCount: perfumes.length,
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final perfume = perfumes[index];

                return Card(
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        perfume["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(
                      perfume["title"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                      ),
                    ),
                    subtitle: Text(
                      "${perfume["brand"]} • ${perfume["price"]} RSD",
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
                          builder: (_) => ProductDetailsScreen(
                            title: perfume["title"]!,
                            brand: perfume["brand"]!,
                            price: perfume["price"]!,
                            image: perfume["image"]!,
                            description: perfume["desc"]!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20), 
        ],
      ),
    );
  }
}