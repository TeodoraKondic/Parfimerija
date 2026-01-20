import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddPerfumeScreen extends StatelessWidget {
  const AddPerfumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add new perfume"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            _field(context, "Title", isDark),
            _field(context, "Brand", isDark),
            _field(context, "Price", isDark),
            _field(context, "Image URL", isDark),
            _field(context, "Description", isDark, maxLines: 4),

            const SizedBox(height: 24),

            SizedBox(
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
                icon: const Icon(Icons.save),
                label: const Text("Add perfume"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Perfume added (fake action)")),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, bool isDark, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        maxLines: maxLines,
        
        style: TextStyle(
          color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? AppColors.softAmber.withValues(alpha: 0.7) : AppColors.chocolateDark.withValues(alpha: 0.7),
          ),
          filled: true,
          fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber, 
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          floatingLabelStyle: TextStyle(
            color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
