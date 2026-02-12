// ignore_for_file: unused_element, unused_field
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routName = "/change-password";
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPassController;
  late TextEditingController _newPassController;
  late TextEditingController _confirmPassController;
  bool _isLoading = false;

  @override
  void initState() {
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }


Future<void> _changePassword() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = userProvider.getUser;
  final currentUid = FirebaseAuth.instance.currentUser?.uid ?? user?.uid;

  if (currentUid == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error: User not found!")),
    );
    setState(() => _isLoading = false);
    return;
  }

  try {
   
    await FirebaseFirestore.instance
        .collection("korisnici")
        .doc(currentUid)
        .update({'password': _newPassController.text.trim()});

  
    await userProvider.fetchUserInfo(currentUid, byUid: true);

    if (mounted) {
      setState(() {
        _oldPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
      });
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated successfully!")),
    );
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Change Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              _buildInputSection(
                label: "Old Password",
                controller: _oldPassController,
                hintText: "Enter your old password",
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _buildInputSection(
                label: "New Password",
                controller: _newPassController,
                hintText: "Enter new password",
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _buildInputSection(
                label: "Confirm Password",
                controller: _confirmPassController,
                hintText: "Repeat new password",
                isDark: isDark,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != _newPassController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
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
                    onPressed: _changePassword,
                    label: const Text(
                      "Update Password",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    icon: const Icon(IconlyLight.lock),
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
    String? Function(String?)? customValidator,
  }) {
    final Color contentColor = isDark ? AppColors.softAmber : AppColors.chocolateDark;
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
          obscureText: true, // Sakriva unos jer je lozinka
          style: TextStyle(color: contentColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            hintText: hintText,
            hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: customValidator ?? 
              (value) => value == null || value.isEmpty ? "$label cannot be empty" : null,
        ),
      ],
    );
  }
}
