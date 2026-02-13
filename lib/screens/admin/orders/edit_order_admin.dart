import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';

class EditOrderScreen extends StatefulWidget {
  final String id;
  final String user;
  final String total;
  final String status;

  const EditOrderScreen({
    super.key,
    required this.id,
    required this.user,
    required this.total,
    required this.status,
  });

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final List<String> statusOptions = ["Pending", "Shipped", "Delivered", "Cancelled", "Completed"];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Edit Order #${widget.id}"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _inputSection(context, "Order ID", widget.id, isDark),
            const SizedBox(height: 16),

         
            _inputSection(context, "User Name", widget.user, isDark),
            const SizedBox(height: 16),

            
            _inputSection(context, "Total Amount", widget.total, isDark),
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

            const SizedBox(height: 30),

           
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
                label: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Order #${widget.id} updated")),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),

          
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Delete Order", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _showDeleteDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _inputSection(BuildContext context, String label, String initialValue, bool isDark) {
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
        TextFormField(
          initialValue: initialValue,
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
          selectedStatus = newValue;
        });
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Delete Order"),
        content: const Text("Are you sure you want to delete this order?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Order deleted")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}