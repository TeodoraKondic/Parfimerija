import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const EditUserScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit User"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field(context, "Name", name, isDark),
            _field(context, "Email", email, isDark),
            _field(context, "Phone", phone, isDark),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User updated (fake action)")),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Delete User"),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, String initialValue, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? AppColors.softAmber.withValues(alpha:0.7) : AppColors.chocolateDark.withValues(alpha:0.7)),
          filled: true,
          fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          floatingLabelStyle: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User deleted (fake action)")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
