import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class EditReviewScreen extends StatefulWidget {
  final String id;        
  final String user;      
  final String perfume;   
  final String text;      
  final String rating;    

  const EditReviewScreen({
    super.key,
    required this.id,
    required this.user,
    required this.perfume,
    required this.text,
    required this.rating,
  });

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  late TextEditingController _userController;
  late TextEditingController _perfumeController;
  late TextEditingController _textController;
  late String selectedRating;

  final List<String> ratingOptions = List.generate(10, (i) => (i + 1).toString());

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController(text: widget.user);
    _perfumeController = TextEditingController(text: widget.perfume);
    _textController = TextEditingController(text: widget.text);
    selectedRating = widget.rating;
  }

  @override
  void dispose() {
    _userController.dispose();
    _perfumeController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _updateReview() async {
    try {
      await FirebaseFirestore.instance.collection('recenzije').doc(widget.id).update({
        'comment': _textController.text,
        'rating': int.tryParse(selectedRating) ?? 0,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review updated successfully!")),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating review: $e")),
      );
    }
  }

  Future<void> _deleteReview() async {
    try {
      await FirebaseFirestore.instance.collection('recenzije').doc(widget.id).delete();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review deleted successfully!")),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting review: $e")),
      );
    }
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
            _inputField("User Name", _userController, isDark, enabled: false),
            const SizedBox(height: 16),
            _inputField("Perfume Name", _perfumeController, isDark, enabled: false),
            const SizedBox(height: 16),
            Text(
              "Rating (1-10)",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
            ),
            const SizedBox(height: 8),
            _ratingDropdown(isDark),
            const SizedBox(height: 16),
            _inputField("Review Text", _textController, isDark, maxLines: 5),
            const SizedBox(height: 30),

            // Dugme za update
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check),
                label: const Text("Update Review",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _updateReview,
              ),
            ),
            const SizedBox(height: 12),

            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete_forever),
                label: const Text("Remove Review",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _confirmDelete(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, bool isDark,
      {int maxLines = 1, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
          style:
              TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _ratingDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      initialValue: selectedRating,
      dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: ratingOptions
          .map((val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
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
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteReview();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
