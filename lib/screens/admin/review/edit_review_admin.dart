import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class EditReviewScreen extends StatefulWidget {
  final String id, user, perfume, text, rating;
  const EditReviewScreen({super.key, required this.id, required this.user, required this.perfume, required this.text, required this.rating});

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  late String selectedRating;
  final List<String> ratingOptions = List.generate(10, (i) => (i + 1).toString());

  @override
  void initState() {
    super.initState();
    selectedRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Review #${widget.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _editInput("User Name", widget.user, isDark),
            const SizedBox(height: 16),
            _editInput("Perfume Name", widget.perfume, isDark),
            const SizedBox(height: 16),
            
            Text("Rating (1-10)", style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
            const SizedBox(height: 8),
            _editRatingDropdown(isDark),
            
            const SizedBox(height: 16),
            _editInput("Review Text", widget.text, isDark, maxLines: 5),
            const SizedBox(height: 30),

            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark, foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check),
                label: const Text("Update Review", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 12),

          
            SizedBox(
              width: double.infinity, height: 55,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete_forever),
                label: const Text("Remove Review", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _confirmDelete(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _editInput(String label, String init, bool isDark, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: init, maxLines: maxLines,
          style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
          decoration: InputDecoration(
            filled: true, fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _editRatingDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: selectedRating,
      dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
      decoration: InputDecoration(
        filled: true, fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: ratingOptions.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
      onChanged: (val) => setState(() => selectedRating = val!),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Delete this review permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(onPressed: () { Navigator.pop(ctx); Navigator.pop(context); }, 
          child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}