import 'package:flutter/material.dart';
//~~~ Made by Riko Gunawan ~~~
import '../models/cart_item.dart';
import '../models/event.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [
    Event(
      id: 1,
      name: 'Minecraft Papercraft Biome',
      price: 999999,
      image: 'mc_papercraft.jpg',
      description:
          'Minecraft Papercraft merupakan sebuah produk miniatur yang terbuat dari rangkaian kertas berwarna khusus dan magnet yang dapat kamu gabungkan menjadi sebuah bangunan atau biome yang kamu inginkan seperti lego! Kenapa tidak mencoba membelinya kalau kamu punya uang?',
    ),
    Event(
      id: 2,
      name: 'Minecraft Bedrock Edition',
      price: 55000,
      image: 'mc_game.jpg',
      description:
          'Minecraft game bisa kamu beli dengan harga spesial! Bedrock edition version',
    ),
    Event(
      id: 3,
      name: 'Headset Creeper Minecraft',
      price: 77000,
      image: 'mc_headset.jpg',
      description: 'Melengkapi kebutuhan gamingmu!',
    ),
    Event(
      id: 4,
      name: 'Minecraft Chicken Egg Cup',
      price: 49999,
      image: 'mc_egg_cup.jpg',
      description:
          'Tempat menaruh 1 telur dengan style minecraft yang sangat lucu',
    ),
    Event(
      id: 5,
      name: 'Torch Light Minecraft',
      price: 59999,
      image: 'mc_torch_light.jpg',
      description: 'Lampu yang bukan sembarang lampu..',
    ),
    Event(
      id: 6,
      name: 'Steven He',
      price: 911,
      image: 'stevenhe.jpg',
      description: 'EMOTIONAL DAMAGE Asian Parent',
    ),
    // Tambahkan produk lain sesuai kebutuhan
  ];
  List<Event> _filteredEvents = []; // Daftar produk yang difilter
  List<Event> get events => _filteredEvents.isEmpty ? _events : _filteredEvents;

  void searchEvent(String query) {
    if (query.isEmpty) {
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events
          .where(
              (event) => event.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // List<event> get events => _events;
  // NOTE! CRUD untuk event tidak diberikan aksesnya kepada user
  // atau tidak dibuatkan screennya, tapi methodnya saya simpan disini
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void editEvent(Event event) {
    final index = _events.indexWhere((element) => element.id == event.id);
    _events[index] = event;
    notifyListeners();
  }

  void removeEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

//_________________________________________________________ Cart System

  // final List<CartItem> _cartItems = [];

  // List<CartItem> get cartItems => _cartItems;

  // void addToCart(Event event, int quantity) {
  //   _cartItems.add(CartItem(event: event, quantity: quantity));
  //   notifyListeners();
  // }

  // // Hitung Total Produk (Getter)
  // double get totalPrice {
  //   return _cartItems.fold(
  //       0, (sum, item) => sum + (item.event.price * item.quantity));
  // }

  // // Checkout
  // void checkout() {
  //   _cartItems.clear();
  //   notifyListeners();
  // }
}
