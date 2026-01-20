import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class EditPerfumeScreen extends StatelessWidget {
  final String title;
  final String brand;
  final String price;
  final String description;
  final String image;

  const EditPerfumeScreen({
    super.key,
    required this.title,
    required this.brand,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final dynamicColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit perfume"),
        backgroundColor: AppColors.chocolateDark,
        foregroundColor: AppColors.softAmber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slika parfema
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            _buildLabel("Brand"),
            _buildTextField(initialValue: brand),

            const SizedBox(height: 16),

            _buildLabel("Perfume name"),
            _buildTextField(initialValue: title),

            const SizedBox(height: 16),

            _buildLabel("Price (RSD)"),
            _buildTextField(
              initialValue: price,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            _buildLabel("Description"),
            _buildTextField(
              initialValue: description,
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changes saved (fake)")),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save changes"),
              ),
            ),

            const SizedBox(height: 16),

            // DELETE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showDeleteDialog(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete perfume"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete perfume"),
        content: const Text(
          "Are you sure you want to delete this perfume?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Perfume deleted (fake)")),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
