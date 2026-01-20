// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routName = "/edit-profile";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(text: "Teodora Kondic");
    _emailController = TextEditingController(
      text: "kondic.it53.2023@uns.ac.rs",
    );
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Ovde ide backend update
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView( // Dodato da tastatura ne bi prekrila polja
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Koristimo istu metodu za polja kao u admin panelu
              _buildInputSection(
                label: "Full Name",
                controller: _nameController,
                hintText: "Enter your full name",
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _buildInputSection(
                label: "Email",
                controller: _emailController,
                hintText: "Enter your email",
                isDark: isDark,
              ),
              
              const SizedBox(height: 40),
              
              Center(
                child: SizedBox(
                  width: double.infinity, // Dugme preko cele širine
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chocolateDark,
                      foregroundColor: AppColors.softAmber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveProfile,
                    label: const Text(
                      "Save Changes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(IconlyLight.tickSquare), // Promenjena ikonica na kvačicu
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pomoćna metoda za kreiranje sekcije polja (isti stil kao admin)
  Widget _buildInputSection({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
  }) {
    // Boja teksta iznad polja i unutar polja
    final Color contentColor = isDark ? AppColors.softAmber : AppColors.chocolateDark;
    // Boja pozadine samog polja
    final Color fieldColor = isDark ? AppColors.chocolateDark : AppColors.softAmber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: contentColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: contentColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            hintText: hintText,
            hintStyle: TextStyle(color: contentColor.withValues(alpha:0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "$label cannot be empty" : null,
        ),
      ],
    );
  }
}