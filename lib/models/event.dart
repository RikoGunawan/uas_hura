class Event {
  int id;
  String name;
  double price;
  String image;
  String description;
  DateTime eventDate;

  Event({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.eventDate,
  });

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price']?.toDouble() ?? 0.0,
        image = json['image'],
        description = json['description'],
        eventDate = DateTime.parse(json['eventDate']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
    };
  }
}
