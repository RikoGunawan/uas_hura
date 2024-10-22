import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();

    final existingProduct =
        ModalRoute.of(context)?.settings.arguments as Product?;
    final isEdit = existingProduct != null;

    if (isEdit) {
      nameController.text = existingProduct.name;
      categoryController.text = existingProduct.category;
      priceController.text = existingProduct.price
          .toString(); // Konversi ke string untuk TextField
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number, // Menggunakan keyboard angka
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final category = categoryController.text;

                // Mengonversi price dari String ke double
                final price = double.tryParse(priceController.text);
                if (price == null) {
                  // Menampilkan pesan kesalahan jika konversi gagal
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Invalid price. Please enter a valid number.'),
                    ),
                  );
                  return;
                }

                final newProduct = Product(
                  id: isEdit
                      ? existingProduct.id
                      : DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  category: category,
                  price: price,
                );

                if (isEdit) {
                  context.read<ProductProvider>().editProduct(newProduct);
                } else {
                  context.read<ProductProvider>().addProduct(newProduct);
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
