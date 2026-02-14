import 'package:cloud_firestore/cloud_firestore.dart';
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
  // Liste za statuse i načine plaćanja
  final List<String> statusOptions = ["pending", "shipped", "delivered", "cancelled", "completed"];
  final List<String> paymentOptions = ["cash", "card"];

  // Selektovane vrednosti
  String selectedStatus = "pending";
  String selectedPayment = "cash";
  String? selectedUid;
  String? selectedProductName;
  
  // Kontroleri i varijable za cenu
  double unitPrice = 0.0; // Cena jednog komada parfema
  final TextEditingController _quantityController = TextEditingController(text: "1");
  double priceTotal = 0.0;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // Funkcija za računanje ukupne cene
  void _calculateTotal() {
    int qty = int.tryParse(_quantityController.text) ?? 0;
    setState(() {
      priceTotal = qty * unitPrice;
    });
  }

  // Funkcija za upis u Firebase
  Future<void> _createOrder() async {
    if (selectedUid == null || selectedProductName == null || priceTotal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill in all fields!")),
      );
      return;
    }

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('porudzbine').doc();
      
      await docRef.set({
        "orderId": docRef.id,
        "uid": selectedUid,
        "productName": selectedProductName,
        "quantity": int.parse(_quantityController.text),
        "priceTotal": priceTotal,
        "status": selectedStatus,
        "paymentMethod": selectedPayment,
      });

      if (mounted) {
        Navigator.pop(context); 
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("New order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _label("Select user", isDark),
            _buildUserDropdown(isDark),
            const SizedBox(height: 16),

        
            _label("Select perfume", isDark),
            _buildProductDropdown(isDark),
            const SizedBox(height: 16),

          
            _label("Quantity", isDark),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? AppColors.softAmber : AppColors.chocolateDark),
              onChanged: (value) => _calculateTotal(), // Reaguje na promenu
              decoration: _inputDecoration(isDark),
            ),
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
                  const Text("Total for payment:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("$priceTotal RSD", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            _label("Method of payment", isDark),
            _buildGenericDropdown(
              paymentOptions, 
              selectedPayment, 
              (val) => setState(() => selectedPayment = val!), 
              isDark
            ),
            const SizedBox(height: 16),

            
            _label("Order status", isDark),
            _buildGenericDropdown(statusOptions, selectedStatus, (val) => setState(() => selectedStatus = val!), isDark),
            
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
                label: const Text("Create an order"),
                onPressed: _createOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- POMOĆNI DROPDOWN-OVI SA STREAMBUILDER-OM ---

  Widget _buildUserDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('korisnici').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: selectedUid,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text("Select a user"),
            items: snapshot.data!.docs.map((doc) {
              return DropdownMenuItem(
                value: doc.id, // UID korisnika
                child: Text(doc['name'] ?? "No name"),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedUid = val),
          ),
        );
      },
    );
  }

  Widget _buildProductDropdown(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('parfemi').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return _dropdownWrapper(
          isDark,
          DropdownButton<String>(
            value: selectedProductName,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text("Select perfume"),
            items: snapshot.data!.docs.map((doc) {
              return DropdownMenuItem(
                value: doc['name'].toString(),
                onTap: () {
                  unitPrice = (doc['price'] as num).toDouble();
                  _calculateTotal();
                },
                child: Text("${doc['name']} (${doc['price']} RSD)"),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedProductName = val),
          ),
        );
      },
    );
  }

  // --- STILIZACIJA ---

  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.softAmber : AppColors.chocolateDark)),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? AppColors.chocolateDark : AppColors.softAmber,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _dropdownWrapper(bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.chocolateDark : AppColors.softAmber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildGenericDropdown(List<String> items, String current, Function(String?) onChange, bool isDark) {
    return _dropdownWrapper(isDark, DropdownButton<String>(
      value: current,
      isExpanded: true,
      underline: const SizedBox(),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChange,
    ));
  }
}


