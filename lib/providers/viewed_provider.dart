import 'package:flutter/material.dart';
import '../models/product.dart';

class ViewedProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addProduct(Product product) {
    // Dodaj proizvod samo ako već nije u listi
    if (!_items.any((p) => p.name == product.name)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((p) => p.name == product.name);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
