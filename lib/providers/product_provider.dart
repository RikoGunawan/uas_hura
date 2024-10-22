import 'package:flutter/material.dart';

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

  final List<Map<Product, int>> _cart = []; // Keranjang produk

  List<Product> get products => _products;
  List<Map<Product, int>> get cart =>
      _cart; // Menambahkan getter untuk keranjang

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

  void addToCart(Product product, int quantity) {
    // Mengecek jika produk sudah ada di keranjang
    final existingProductIndex =
        _cart.indexWhere((item) => item.keys.first.id == product.id);
    if (existingProductIndex != -1) {
      // Jika produk sudah ada, update kuantitasnya
      _cart[existingProductIndex][product] =
          _cart[existingProductIndex][product]! + quantity;
    } else {
      // Jika produk belum ada, tambahkan ke keranjang
      _cart.add({product: quantity});
    }
    notifyListeners();
  }
}
