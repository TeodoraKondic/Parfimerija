import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('parfemi');

 
  Future<List<Product>> getProducts() async {
    final snapshot = await _products.get();

    return snapshot.docs.map((doc) {
      return Product.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  
  Future<void> addProduct(Product product) async {
    await _products.add({
      'name': product.name,
      'brand': product.brand,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
    });
  }

  Future<void> updateProduct(Product product) async {
    await _products.doc(product.id).update({
      'name': product.name,
      'brand': product.brand,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
    });
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}
