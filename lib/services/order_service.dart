import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection('porudzbine');

  // Dohvati sve porudzbine
  Stream<List<OrderModel>> getOrders() {
    return _orders.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromFirestore(data);
      }).toList();
    });
  }

  // Update status porudzbine
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final query = await _orders.where('orderId', isEqualTo: orderId).get();
    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({'status': newStatus});
    } else {
      throw Exception("Order with ID $orderId not found");
    }
  }

  // Brisanje porudzbine
  Future<void> deleteOrder(String orderId) async {
    final query = await _orders.where('orderId', isEqualTo: orderId).get();
    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.delete();
    } else {
      throw Exception("Order with ID $orderId not found");
    }
  }
}
class UserService {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<String> getUserNameByUid(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] ?? 'Unknown User';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      return 'Unknown User';
    }
  }
}
