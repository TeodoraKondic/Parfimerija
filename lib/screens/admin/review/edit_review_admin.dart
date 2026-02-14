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
  final List<String> ratingOptions =
      List.generate(10, (i) => (i + 1).toString());

  String? selectedUserName;
  String? selectedPerfumeName;
  String selectedRating = "10";

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    selectedUserName =
        widget.user.isEmpty ? null : widget.user;

    selectedPerfumeName =
        widget.perfume.isEmpty ? null : widget.perfume;

    selectedRating = widget.rating;
    _textController =
        TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

 
  Future<void> _updateReview() async {
    try {
      await FirebaseFirestore.instance
          .collection('recenzije')
          .doc(widget.id)
          .update({
        'userName': selectedUserName,
        'perfumeName': selectedPerfumeName,
        'reviewText': _textController.text,
        'rating': int.tryParse(selectedRating) ?? 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Review updated successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error updating review: $e")),
      );
    }
  }

 
  Future<void> _deleteReview() async {
    try {
      await FirebaseFirestore.instance
          .collection('recenzije')
          .doc(widget.id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Review deleted successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error deleting review: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context)
            .getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit review")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _label("Select user", isDark),
            _buildUserDropdown(isDark),
            const SizedBox(height: 16),

            _label("Select perfume", isDark),
            _buildPerfumeDropdown(isDark),
            const SizedBox(height: 16),

            _label("Rating (1-10)", isDark),
            _ratingDropdown(isDark),
            const SizedBox(height: 16),

            _label("Review text", isDark),
            _textField(isDark),
            const SizedBox(height: 30),

            // UPDATE
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.chocolateDark,
                  foregroundColor:
                      AppColors.softAmber,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            12),
                  ),
                ),
                icon: const Icon(Icons.check),
                label: const Text(
                  "Update review",
                  style: TextStyle(
                      fontWeight:
                          FontWeight.bold),
                ),
                onPressed: _updateReview,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      Colors.redAccent,
                  side: const BorderSide(
                      color: Colors.redAccent,
                      width: 1.5),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            12),
                  ),
                ),
                icon: const Icon(
                    Icons.delete_forever),
                label: const Text(
                  "Remove review",
                  style: TextStyle(
                      fontWeight:
                          FontWeight.bold),
                ),
                onPressed: () =>
                    _confirmDelete(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('korisnici')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final docs = snapshot.data!.docs;

     
        final exists = docs.any((doc) {
          final data =
              doc.data() as Map<String, dynamic>;
          return data['name'] ==
              selectedUserName;
        });

        final safeValue =
            exists ? selectedUserName : null;

        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: safeValue,
            hint: const Text("Select user"),
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark
                ? AppColors.chocolateDark
                : AppColors.softAmber,
            style: TextStyle(
              color: isDark
                  ? AppColors.softAmber
                  : AppColors.chocolateDark,
            ),
            items: docs.map((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;
              final name =
                  data['name'] ?? "No name";

              return DropdownMenuItem<
                  String>(
                value: name.toString(),
                child:
                    Text(name.toString()),
              );
            }).toList(),
            onChanged: (val) =>
                setState(() =>
                    selectedUserName = val),
          ),
        );
      },
    );
  }


  Widget _buildPerfumeDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parfemi')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        final exists = docs.any((doc) {
          final data =
              doc.data() as Map<String, dynamic>;
          return data['name'] ==
              selectedPerfumeName;
        });

        final safeValue =
            exists ? selectedPerfumeName : null;

        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: safeValue,
            hint: const Text("Select perfume"),
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark
                ? AppColors.chocolateDark
                : AppColors.softAmber,
            style: TextStyle(
              color: isDark
                  ? AppColors.softAmber
                  : AppColors.chocolateDark,
            ),
            items: docs.map((doc) {
              final data =
                  doc.data()
                      as Map<String, dynamic>;
              final name =
                  data['name'] ?? "Unknown";

              return DropdownMenuItem<
                  String>(
                value: name.toString(),
                child:
                    Text(name.toString()),
              );
            }).toList(),
            onChanged: (val) =>
                setState(() =>
                    selectedPerfumeName =
                        val),
          ),
        );
      },
    );
  }


  Widget _textField(bool isDark) {
    return TextField(
      controller: _textController,
      maxLines: 5,
      style: TextStyle(
        color: isDark
            ? AppColors.softAmber
            : AppColors.chocolateDark,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? AppColors.chocolateDark
            : AppColors.softAmber,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Widget _ratingDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      initialValue: selectedRating,
      dropdownColor: isDark
          ? AppColors.chocolateDark
          : AppColors.softAmber,
      style: TextStyle(
        color: isDark
            ? AppColors.softAmber
            : AppColors.chocolateDark,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark
            ? AppColors.chocolateDark
            : AppColors.softAmber,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: ratingOptions
          .map((val) => DropdownMenuItem(
              value: val, child: Text(val)))
          .toList(),
      onChanged: (val) =>
          setState(() =>
              selectedRating = val!),
    );
  }

  Widget _label(String text, bool isDark) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark
              ? AppColors.softAmber
              : AppColors.chocolateDark,
        ),
      ),
    );
  }

  Widget _dropdownWrapper(
      bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.chocolateDark
            : AppColors.softAmber,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  void _confirmDelete(
      BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            const Text("Confirm felete"),
        content: const Text(
            "Delete this review permanently?"),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pop(ctx),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteReview();
            },
            child: const Text("Delete",
                style: TextStyle(
                    color: Colors.red)),
          ),
        ],
      ),
    );
  }
}




