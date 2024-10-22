import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 1,
      name: 'Minecraft Papercraft Biome',
      price: 999999,
      image: 'assets/mc_papercraft.jpg',
      description:
          'Minecraft Papercraft merupakan sebuah produk miniatur yang terbuat dari rangkaian kertas berwarna khusus dan magnet yang dapat kamu gabungkan menjadi sebuah bangunan atau biome yang kamu inginkan seperti lego! Kenapa tidak mencoba membelinya kalau kamu punya uang?',
    ),
    // Tambahkan produk lain sesuai kebutuhan
  ];

  List<Product> get products => _products;

  Product findById(int id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void editProduct(Product product) {
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void clearProducts() {
    _products.clear();
    notifyListeners();
  }

  // Hitung Total Produk
  double get totalPrice {
    double total = 0;
    for (var item in _products) {
      total += item.price;
    }
    return total;
  }

  // Checkout
  void checkout() {
    _products.clear();
    notifyListeners();
  }

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product, int quantity) {
    _cartItems.add(CartItem(product: product, quantity: quantity));
    notifyListeners();
  }
}
