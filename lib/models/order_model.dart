class OrderModel {
  final String orderId;
  final String paymentMethod;
  final double priceTotal;
  final String productName;
  final int quantity;
  final String status;
  final String uid;

  OrderModel({
    required this.orderId,
    required this.paymentMethod,
    required this.priceTotal,
    required this.productName,
    required this.quantity,
    required this.status,
    required this.uid,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data) {
    return OrderModel(
      orderId: data['orderId'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      priceTotal: (data['priceTotal'] ?? 0).toDouble(),
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      status: data['status'] ?? 'pending',
      uid: data['uid'] ?? '',
    );
  }
}