import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String> paymentOptions = ["cash", "card"];

  
  String? selectedStatus;
  String? selectedPayment;
  String? selectedUid;
  String? selectedProductName;
  double unitPrice = 0.0;
  double priceTotal = 0.0;
  bool _isLoading = true; 
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  
  Future<void> _fetchOrderDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('porudzbine')
          .doc(widget.id)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          selectedStatus = data['status'] ?? widget.status;
          selectedPayment = data['paymentMethod'] ?? "cash";
          selectedUid = data['uid'] ?? widget.user;
          selectedProductName = data['productName'];
          _quantityController.text = (data['quantity'] ?? 1).toString();
          priceTotal = (data['priceTotal'] as num).toDouble();
          
          
          int qty = data['quantity'] ?? 1;
          unitPrice = priceTotal / qty;
          
          _isLoading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Loading error: $e");
    }
  }

  void _calculateTotal() {
    int qty = int.tryParse(_quantityController.text) ?? 0;
    setState(() {
      priceTotal = qty * unitPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text("Edit order #${widget.id}")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("User", isDark),
                _buildUserDropdown(isDark),
                const SizedBox(height: 16),

                _label("Perfume", isDark),
                _buildProductDropdown(isDark),
                const SizedBox(height: 16),

                _label("Quantity", isDark),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
                  onChanged: (value) => _calculateTotal(),
                  decoration: _inputDecoration(isDark),
                ),
                const SizedBox(height: 16),

                _label("Payment method", isDark),
                _buildGenericDropdown(paymentOptions, selectedPayment!, (val) => setState(() => selectedPayment = val), isDark),
                const SizedBox(height: 16),

                _label("Status", isDark),
                _buildGenericDropdown(statusOptions, selectedStatus!, (val) => setState(() => selectedStatus = val), isDark),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: isDark ? AppColors.chocolateDark.withOpacity(0.5) : AppColors.softAmber.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("$priceTotal RSD", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
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
                    label: const Text("Save changes"),
                    onPressed: _updateOrder,
                  ),
                ),
                const SizedBox(height: 12),
                
            
                _deleteButton(),
              ],
            ),
          ),
    );
  }


  Future<void> _updateOrder() async {
    try {
      await FirebaseFirestore.instance.collection('porudzbine').doc(widget.id).update({
        "uid": selectedUid,
        "productName": selectedProductName,
        "quantity": int.tryParse(_quantityController.text) ?? 1,
        "priceTotal": priceTotal,
        "status": selectedStatus,
        "paymentMethod": selectedPayment,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully edited!")));
        Navigator.pop(context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }


  Widget _buildUserDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('korisnici').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _dropdownWrapper(isDark, DropdownButton<String>(
          value: selectedUid,
          isExpanded: true,
          underline: const SizedBox(),
          items: snapshot.data!.docs.map((doc) => DropdownMenuItem(
            value: doc.id,
            child: Text(doc['name'] ?? "No name"),
          )).toList(),
          onChanged: (val) => setState(() => selectedUid = val),
        ));
      },
    );
  }

  Widget _buildProductDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('parfemi').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _dropdownWrapper(isDark, DropdownButton<String>(
          value: selectedProductName,
          isExpanded: true,
          underline: const SizedBox(),
          items: snapshot.data!.docs.map((doc) => DropdownMenuItem(
            value: doc['name'].toString(),
            onTap: () {
              unitPrice = (doc['price'] as num).toDouble();
              _calculateTotal();
            },
            child: Text("${doc['name']} (${doc['price']} RSD)"),
          )).toList(),
          onChanged: (val) => setState(() => selectedProductName = val),
        ));
      },
    );
  }

  Widget _buildGenericDropdown(List<String> items, String current, Function(String?) onChange, bool isDark) {
    return _dropdownWrapper(isDark, DropdownButton<String>(
      value: current, isExpanded: true, underline: const SizedBox(),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChange,
    ));
  }

  Widget _label(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
  );

  InputDecoration _inputDecoration(bool isDark) => InputDecoration(
    filled: true, fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  );

  Widget _dropdownWrapper(bool isDark, Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: isDark ? AppColors.chocolateDark : AppColors.softAmber, borderRadius: BorderRadius.circular(12)),
    child: child,
  );

  Widget _deleteButton() {
     return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.delete),
        label: const Text("Delete order"),
        onPressed: () => _showDeleteDialog(context),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm delete"),
        content: const Text("Delete this order permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(onPressed: () { 
            Navigator.pop(ctx); 
             // ignore: use_build_context_synchronously
             _orderService.deleteOrder(widget.id).then((_) => Navigator.pop(context));
          }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}