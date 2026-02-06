import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = []; // svi proizvodi iz baze

  List<Product> get products => _products;

  // metoda za postavljanje/učitavanje proizvoda iz baze
  void setProducts(List<Product> productsFromDb) {
    _products = productsFromDb;
    notifyListeners();
  }

  // najnoviji n proizvoda
  List<Product> latestArrivals(int n) {
    final sorted = [..._products];
    sorted.sort((a, b) => b.id.compareTo(a.id)); // najveći id prvi
    return sorted.take(n).toList();
  }
}
