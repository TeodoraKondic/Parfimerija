import 'package:flutter/material.dart';
//import 'package:parfimerija_app/widgets/subtitle_text.dart';
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
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: "Bulevar oslobođenja 88, Novi Sad");
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitelesTextWidget(label: "Your Address",color: Theme.of(context,).textTheme.titleLarge?.color,),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "Enter your address",
                filled: true,
                fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                onPressed: () {
            // ignore: avoid_print
                  print("Nova adresa: ${_addressController.text}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Address updated!")),
                  );
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
