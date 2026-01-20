import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final List<String> ratingOptions = List.generate(10, (i) => (i + 1).toString());
  String selectedRating = "10";

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Review")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputSection("User Name", isDark),
            const SizedBox(height: 16),
            _inputSection("Perfume Name", isDark),
            const SizedBox(height: 16),
            
            Text("Rating (1-10)", 
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
            const SizedBox(height: 8),
            _ratingDropdown(isDark),
            
            const SizedBox(height: 16),
            _inputSection("Review Text", isDark, maxLines: 5),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: const Text("Save Review", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: selectedRating,
      dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: ratingOptions.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
      onChanged: (val) => setState(() => selectedRating = val!),
    );
  }

  Widget _inputSection(String label, bool isDark, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}