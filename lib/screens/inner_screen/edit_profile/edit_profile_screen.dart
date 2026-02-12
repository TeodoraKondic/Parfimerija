// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
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
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userModel = userProvider.getUser;

    _nameController = TextEditingController(text: userModel?.name ?? "");
    _emailController = TextEditingController(text: userModel?.email ?? "");
    _phoneController = TextEditingController(
      text: userModel?.phoneNumber ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    User? user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? currentUid = user?.uid ?? userProvider.getUser?.uid;

    if (currentUid == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("korisnici")
          .doc(currentUid)
          .update({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
          });

      if (user != null && _emailController.text.trim() != user.email) {
        // ignore: deprecated_member_use
        await user.updateEmail(_emailController.text.trim());
      }

      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      await userProvider.fetchUserInfo(_emailController.text.trim());

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      userProvider.notifyListeners();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profil uspešno ažuriran!")));

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Greška: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 16),
              _buildInputSection(
                label: "Phone Number",
                controller: _phoneController,
                hintText: "Enter your phone",
                isDark: isDark,
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
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
                    onPressed: _isLoading ? null : _saveProfile,
                    label: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    icon: _isLoading
                        ? const SizedBox()
                        : const Icon(IconlyLight.tickSquare),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
  }) {
    final Color contentColor = isDark
        ? AppColors.softAmber
        : AppColors.chocolateDark;
    final Color fieldColor = isDark
        ? AppColors.chocolateDark
        : AppColors.softAmber;

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
            // ignore: deprecated_member_use
            hintStyle: TextStyle(color: contentColor.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "$label cannot be empty" : null,
        ),
      ],
    );
  }
}
