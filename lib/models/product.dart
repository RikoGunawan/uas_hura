class Product {
  int id;
  String name;
  String category;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        price = json['price']?.toDouble() ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
    };
  }
}
