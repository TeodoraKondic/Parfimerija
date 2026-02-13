import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class EditPerfumeScreen extends StatelessWidget {
  final String title;
  final String brand;
  final String price;
  final String description;
  final String image;

  const EditPerfumeScreen({
    super.key,
    required this.title,
    required this.brand,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const TitelesTextWidget(label: "Edit perfume"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
  child: Container(

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).cardColor,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        image,
        height: 250, 
        fit: BoxFit.contain, 
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
      ),
    ),
  ),
),
            const SizedBox(height: 30),

            _inputSection(context, "Brand", brand),
            const SizedBox(height: 16),
            _inputSection(context, "Perfume name", title),
            const SizedBox(height: 16),
            _inputSection(context, "Price (RSD)", price, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _inputSection(context, "Description", description, maxLines: 4),

            const SizedBox(height: 10), 

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changes saved!")),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save changes", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete),
                label: const Text("Delete perfume", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _inputSection(
  BuildContext context,
  String label,
  String initialValue, {
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
}) {
  final bool isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        keyboardType: keyboardType,
       
        style: TextStyle(
          color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ],
  );
}
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Delete perfume"),
        content: const Text("Are you sure you want to delete this perfume?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Perfume deleted!")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}