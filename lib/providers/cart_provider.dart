import 'package:flutter/material.dart';
import '../models/product.dart'; // tvoj Product model

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  // Dodavanje proizvoda u korpu
  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  // Uklanjanje proizvoda iz korpe
  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  // Brisanje svih proizvoda iz korpe
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  void updateQuantity(Product product, int quantity) {
  final index = _items.indexWhere((p) => p.id == product.id);
  if (index != -1) {
    _items[index].quantity = quantity;
    notifyListeners();
  }
}

  // Ukupan broj proizvoda
  int get itemCount => _items.length;

  // Ukupna cena
  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price);

}
