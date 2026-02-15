import 'package:flutter/material.dart';
import 'package:parfimerija_app/models/product.dart'; // Proveri putanju do modela

class WishlistProvider with ChangeNotifier {
  // Mapa gde je ključ ID proizvoda (String), a vrednost ceo Product objekat
  final Map<String, Product> _wishlistItems = {};

  Map<String, Product> get getWishlistItems {
    return _wishlistItems;
  }

  // Provera da li je proizvod u listi (koristi se za boju srca)
  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }

  // Glavna funkcija za srce: ako ga nema dodaj ga, ako ga ima izbaci ga
  void addOrRemoveFromWishlist({required Product product}) {
    if (_wishlistItems.containsKey(product.id)) {
      _wishlistItems.remove(product.id);
    } else {
      _wishlistItems.putIfAbsent(
        product.id,
        () => product,
      );
    }
    notifyListeners(); // Ovo javlja ekranu da se osveži
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}