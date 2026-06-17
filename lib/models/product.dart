class Product {
  final int id;
  final int userId;
  final String name;
  final double price;
  final String description;
  final int stock;
  final String imageUrl;
  final String category;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.description,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'price': price,
      'description': description,
      'stock': stock,
      'image_url': imageUrl,
      'category': category,
    };
  }
}