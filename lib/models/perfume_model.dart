class Perfume {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;

  Perfume({required this.id, required this.name, required this.brand, required this.price, required this.imageUrl});
}

List<Perfume> dummyPerfumes = [
  Perfume(id: '1', name: 'No. 5', brand: 'Chanel', price: 120.0, imageUrl: 'https://via.placeholder.com/150'),
  Perfume(id: '2', name: 'Sauvage', brand: 'Dior', price: 95.0, imageUrl: 'https://via.placeholder.com/150'),
  Perfume(id: '3', name: 'Black Opium', brand: 'Yves Saint Laurent', price: 110.0, imageUrl: 'https://images.unsplash.com/photo-1615037546137-97554f762634?q=80&w=2000'),
  Perfume(id: '4', name: 'Baccarat Rouge 540', brand: 'Maison Francis Kurkdjian', price: 280.0, imageUrl: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?q=80&w=2000'),
  Perfume(id: '5', name: 'Eros', brand: 'Versace', price: 85.0, imageUrl: 'https://images.unsplash.com/photo-1557170334-a9632e77c6e4?q=80&w=2000'),
  Perfume(id: '6', name: 'Light Blue', brand: 'Dolce & Gabbana', price: 75.0, imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?q=80&w=2000'),
];