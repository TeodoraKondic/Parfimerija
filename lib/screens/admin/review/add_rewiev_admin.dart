import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
 
  final List<String> ratingOptions = List.generate(10, (i) => (i + 1).toString());
  
  String selectedRating = "10";
  String? selectedUid;         
  String? selectedUserName;    
  String? selectedPerfumeName;

  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }


  Future<void> _saveReview() async {
    if (selectedUid == null || selectedPerfumeName == null || _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
      return;
    }

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('recenzije').doc();

      await docRef.set({
        "reviewId": docRef.id,
        "uid": selectedUid,
        "userName": selectedUserName, 
        "perfumeName": selectedPerfumeName,
        "rating": int.parse(selectedRating),
        "reviewText": _reviewController.text,
        "createdAt": Timestamp.now(),
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;
    final primaryColor = isDark ? AppColors.softAmber : AppColors.chocolateDark;

    return Scaffold(
      appBar: AppBar(title: const Text("Add new review")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            _label("Select user", isDark),
            _buildUserDropdown(isDark),
            const SizedBox(height: 16),

            _label("Select perfume", isDark),
            _buildPerfumeDropdown(isDark),
            const SizedBox(height: 16),

            
            _label("Rating (1-10)", isDark),
            _buildGenericDropdown(ratingOptions, selectedRating, (val) {
              setState(() => selectedRating = val!);
            }, isDark),
            const SizedBox(height: 16),

            _label("Review text", isDark),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              style: TextStyle(color: primaryColor),
              decoration: _inputDecoration(isDark),
            ),
            const SizedBox(height: 32),

           
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.chocolateDark,
                  foregroundColor: AppColors.softAmber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save),
                label: const Text("Save review", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: _saveReview,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUserDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('korisnici').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        
        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: selectedUid,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text("Select a user", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
            dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
            items: snapshot.data!.docs.map((doc) {
              return DropdownMenuItem(
                value: doc.id,
                child: Text(doc['name'] ?? "No name"),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedUid = val;
           
                selectedUserName = snapshot.data!.docs
                    .firstWhere((doc) => doc.id == val)['name'];
              });
            },
          ),
        );
      },
    );
  }


  Widget _buildPerfumeDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('parfemi').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        
        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: selectedPerfumeName,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text("Select perfume", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
            dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
            items: snapshot.data!.docs.map((doc) {
              String name = doc['name'] ?? "Unknown";
              return DropdownMenuItem(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedPerfumeName = val),
          ),
        );
      },
    );
  }



  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _dropdownWrapper(bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.black12.withOpacity(0.05)),
      ),
      child: child,
    );
  }

  Widget _buildGenericDropdown(List<String> items, String current,
      Function(String?) onChange, bool isDark) {
    return _dropdownWrapper(
      isDark,
      DropdownButton<String>(
        value: current,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChange,
      ),
    );
  }
}