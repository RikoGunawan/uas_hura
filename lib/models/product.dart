class Product {
  int id;
  String name;
  double price;
  String image;
  String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price']?.toDouble() ?? 0.0,
        image = json['image'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}
//~~~ Made by Riko Gunawan ~~~