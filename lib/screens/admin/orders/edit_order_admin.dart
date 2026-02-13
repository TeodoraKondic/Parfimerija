import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:provider/provider.dart';
import '../../../services/order_service.dart';

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
  final OrderService _orderService = OrderService();
  final List<String> statusOptions = ["pending", "shipped", "delivered", "cancelled", "completed"];
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
            _inputSection("Order ID", widget.id, isDark, enabled: false),
            const SizedBox(height: 16),
            _inputSection("User Name", widget.user, isDark, enabled: false),
            const SizedBox(height: 16),
            _inputSection("Total Amount", widget.total, isDark, enabled: false),
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
            _statusDropdown(isDark),
            const SizedBox(height: 30),
            // Dugme za update
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
                onPressed: _updateOrder,
              ),
            ),
            const SizedBox(height: 16),
            // Dugme za delete
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

  Widget _inputSection(String label, String value, bool isDark, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: enabled,
          style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _statusDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      value: selectedStatus,
      dropdownColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: statusOptions.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
      onChanged: (newValue) => setState(() => selectedStatus = newValue),
    );
  }

  Future<void> _updateOrder() async {
    try {
      await _orderService.updateOrderStatus(widget.id, selectedStatus ?? widget.status);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order #${widget.id} updated successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating order: $e")));
    }
  }

  Future<void> _deleteOrder() async {
    try {
      await _orderService.deleteOrder(widget.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order #${widget.id} deleted successfully!")));
      Navigator.pop(context); // zatvori ekran
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting order: $e")));
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Delete this order permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteOrder();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
