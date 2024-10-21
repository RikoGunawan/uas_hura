import 'package:flutter/material.dart';

import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //(Note) Antisipasi Keyboard Menggeser Layout
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/mc_papercraft.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minecraft Papercraft Biome',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Rp 999.999',
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Minecraft Papercraft merupakan sebuah produk miniatur yang terbuat dari rangkaian kertas berwarna khusus dan magnet yang dapat kamu gabungkan menjadi sebuah bangunan atau biome yang kamu inginkan seperti lego! Kenapa tidak mencoba membelinya kalau kamu punya uang?',
                        style: TextStyle(
                          fontSize: 12,
                          // fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      child: const Icon(Icons.remove, size: 9),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      controller: TextEditingController(text: '$quantity'),
                      style: const TextStyle(fontSize: 9),
                      onChanged: (value) => quantity = int.tryParse(value) ?? 1,
                    ),
                  ),
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: const Icon(Icons.add, size: 9),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk add to cart
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
