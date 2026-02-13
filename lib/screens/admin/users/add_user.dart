import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(); 
  final TextEditingController _imageController = TextEditingController();  
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _imageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _saveUser() async {
    if (_emailController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and name are required!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Generišemo ID
      String tempUid = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance.collection('korisnici').doc(tempUid).set({
        'uid': tempUid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.isEmpty ? "Not entered" : _addressController.text.trim(), 
        'role': 'user',
        'userImage': _imageController.text.trim(), 
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add New User"),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _field(context, "Full Name", isDark, controller: _nameController),
                _field(context, "Email", isDark, controller: _emailController, keyboardType: TextInputType.emailAddress),
                _field(context, "Phone", isDark, controller: _phoneController, keyboardType: TextInputType.phone),
                _field(context, "Address", isDark, controller: _addressController), 
                _field(context, "Image URL", isDark, controller: _imageController), 
                _field(context, "Password", isDark, controller: _passwordController, obscureText: true),
                
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
                    label: const Text("Add User"),
                    onPressed: _saveUser,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _field(BuildContext context, String label, bool isDark, 
      {bool obscureText = false, TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark 
              // ignore: deprecated_member_use
              ? AppColors.softAmber.withOpacity(0.7) 
              // ignore: deprecated_member_use
              : AppColors.chocolateDark.withOpacity(0.7)
          ),
          filled: true,
          fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          floatingLabelStyle: TextStyle(
            color: isDark ? AppColors.softAmber : AppColors.chocolateDark, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}