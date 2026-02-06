class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String description;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.quantity = 1,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
