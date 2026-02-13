import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddPerfumeScreen extends StatefulWidget {
  const AddPerfumeScreen({super.key});

  @override
  State<AddPerfumeScreen> createState() => _AddPerfumeScreenState();
}

class _AddPerfumeScreenState extends State<AddPerfumeScreen> {
  // Kontroleri za polja koja ti trebaju
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _savePerfume() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Popunite bar Naziv i Cenu")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('parfemi').add({
        'name': _nameController.text.trim(),
        'brand': _brandController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'imageUrl': _imageUrlController.text.trim(),
        'description': _descriptionController.text.trim(),
      });

      if (!mounted) return;
      
    
      Navigator.pop(context, true); 
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Greška: $e")),
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
      appBar: AppBar(title: const Text("Add new perfume")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _field(context, "Name", isDark, controller: _nameController),
                _field(context, "Brand", isDark, controller: _brandController),
                _field(context, "Price", isDark, controller: _priceController, keyboardType: TextInputType.number),
                _field(context, "Image URL", isDark, controller: _imageUrlController),
                _field(context, "Description", isDark, controller: _descriptionController, maxLines: 4),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.chocolateDark,
                      foregroundColor: AppColors.softAmber,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text("Add perfume"),
                    onPressed: _savePerfume,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _field(BuildContext context, String label, bool isDark, {int maxLines = 1, TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}