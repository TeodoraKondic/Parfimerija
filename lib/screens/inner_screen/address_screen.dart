import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';

class AddressScreen extends StatefulWidget {
  static const routName = "/AddressScreen";
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>(); // <-- OVDE
  late TextEditingController _addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _addressController = TextEditingController(
      text: userProvider.getUser?.address ?? "",
    );

    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        await userProvider.fetchUserInfo(user.email!);
        if (mounted) {
          setState(() {
            _addressController.text = userProvider.getUser?.address ?? "";
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    if (!_formKey.currentState!.validate()) return; 

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final currentUid = user?.uid ?? userProvider.getUser?.uid;

    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User not found!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      
      await FirebaseFirestore.instance
          .collection("korisnici")
          .doc(currentUid)
          .update({'address': _addressController.text.trim()});

      
      await userProvider.fetchUserInfo(currentUid, byUid: true);

    
      if (mounted) {
        setState(() {
          _addressController.text = userProvider.getUser?.address ?? "";
        });
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address successfully saved!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( 
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitelesTextWidget(
                label: "Your Address",
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your address";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Enter your address",
                  filled: true,
                  fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                    foregroundColor: isDark ? AppColors.softAmber : AppColors.chocolateDark,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _updateAddress,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

