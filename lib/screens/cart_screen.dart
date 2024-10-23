import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/product_provider.dart';
import 'product_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final cartItems = provider.cartItems; // Mengambil item keranjang

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(''),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (cartItems.isEmpty) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 0),
                  child: Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('Your cart is empty'),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 22.0),
                  child: Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      150, // Mengatur tinggi list agar fleksibel
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final totalPrice =
                          cartItem.product.price * cartItem.quantity;

                      return InkWell(
                        onTap: () {
                          // NAVIGASI
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: cartItem.product,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black), // Border
                          ),
                          child: Row(
                            children: [
                              // Gambar Mini di Sebelah Kiri
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.asset(
                                  cartItem.product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey,
                                    child: const Center(
                                        child: Text('Image not found')),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        cartItem.product.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(cartItem.product.price)} x${cartItem.quantity}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(totalPrice),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      //BOTTOM APP BAR
      bottomNavigationBar: BottomAppBar(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Total Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(provider.totalPrice)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.checkout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan anda diproses ^_^'),
                  ),
                );
                Navigator.pushNamed(context, '/checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
