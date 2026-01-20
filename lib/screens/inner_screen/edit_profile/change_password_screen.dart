// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
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

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // backend logika
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPassController,
                decoration: const InputDecoration(labelText: "Old Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Enter old password" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPassController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Enter new password" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPassController,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (value) =>
                    value != _newPassController.text ? "Passwords do not match" : null,
              ),
              const SizedBox(height: 30),
                 Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.getIsDarkTheme
                        ? AppColors.chocolateDark
                        : AppColors.softAmber,
                    foregroundColor: themeProvider.getIsDarkTheme
                        ? AppColors.softAmber
                        : AppColors.chocolateDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  label: const Text("Change Password"),
                  icon: const Icon(IconlyLight.logout),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
