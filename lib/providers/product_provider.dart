import 'package:flutter/material.dart';
//Made by Riko Gunawan
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
  List<Product> _filteredProducts = []; // Daftar produk yang difilter
  List<Product> get products =>
      _filteredProducts.isEmpty ? _products : _filteredProducts;

  void searchProduct(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // List<Product> get products => _products;

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

//_________________________________________________________ Cart System

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(Product product, int quantity) {
    _cartItems.add(CartItem(product: product, quantity: quantity));
    notifyListeners();
  }

  // Hitung Total Produk (Getter)
  double get totalPrice {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Checkout
  void checkout() {
    _cartItems.clear();
    notifyListeners();
  }
}
