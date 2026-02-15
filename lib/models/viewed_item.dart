class ViewedItem {
  final String id;
  final String name;
  final String imageUrl;

  ViewedItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory ViewedItem.fromMap(Map<String, dynamic> map) {
    return ViewedItem(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
}
