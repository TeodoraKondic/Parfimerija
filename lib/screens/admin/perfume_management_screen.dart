import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/admin/add_perfume.dart';
import 'package:parfimerija_app/screens/product_details_screen.dart';
import 'package:parfimerija_app/services/product_service.dart';
import 'package:provider/provider.dart';

class PerfumeManagementScreen extends StatefulWidget {
  const PerfumeManagementScreen({super.key});

  @override
  State<PerfumeManagementScreen> createState() =>
      _PerfumeManagementScreenState();
}

class _PerfumeManagementScreenState extends State<PerfumeManagementScreen> {
  final ProductService _service = ProductService();
  List<Product> perfumes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPerfumes();
  }

  Future<void> loadPerfumes() async {
    perfumes = await _service.getProducts(); // Učitava iz baze / servisa
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Perfume Management"),
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
                    MaterialPageRoute(builder: (_) => const AddPerfumeScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Perfume",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              itemCount: perfumes.length,
              itemBuilder: (context, index) {
                final perfume = perfumes[index];
                return Card(
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        perfume.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(
                      perfume.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.chocolateDark
                            : AppColors.softAmber,
                      ),
                    ),
                    subtitle: Text(
                      "${perfume.brand} • ${perfume.price} RSD",
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
                          builder: (_) => ProductDetailsScreen(
                            title: perfume.name,
                            brand: perfume.brand,
                            price: perfume.price.toString(),
                            image: perfume.imageUrl,
                            description: perfume.description,
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
