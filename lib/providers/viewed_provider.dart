import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewedProvider with ChangeNotifier {
  List<String> _items = [];
  List<String> get items => _items;

  static const String _key = "recentlyViewed";

  Future<void> loadViewed() async {
    final prefs = await SharedPreferences.getInstance();
    _items = prefs.getStringList(_key) ?? [];
    notifyListeners();
  }

  Future<void> addItem(String productName) async {
    _items.remove(productName);
    _items.insert(0, productName);

    if (_items.length > 10) {
      _items = _items.sublist(0, 10);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _items);

    notifyListeners();
  }

  // ✅ DODAJ OVO
  Future<void> clear() async {
    _items.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);

    notifyListeners();
  }
}
