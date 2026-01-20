import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final List<String> statusOptions = ["Pending", "Shipped", "Delivered", "Cancelled", "Completed"];
  String selectedStatus = "Pending";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add New Order"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            _inputSection(context, "Order ID", isDark),
            const SizedBox(height: 16),
            
            _inputSection(context, "User Name", isDark),
            const SizedBox(height: 16),
            
            _inputSection(context, "Total Amount", isDark),
            const SizedBox(height: 16),

            
            Text(
              "Order Status",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
              ),
            ),
            const SizedBox(height: 8),
            _statusDropdown(context, isDark),

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
                icon: const Icon(Icons.add_task),
                label: const Text(
                  "Create Order", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order created successfully!")),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _inputSection(BuildContext context, String label, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.softAmber : AppColors.chocolateDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }


  Widget _statusDropdown(BuildContext context, bool isDark) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: selectedStatus,
      dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: statusOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedStatus = newValue!;
        });
      },
    );
  }
}
