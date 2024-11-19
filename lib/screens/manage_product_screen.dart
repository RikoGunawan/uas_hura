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
    final priceController = TextEditingController();
    final imageController = TextEditingController();
    final descriptionController = TextEditingController();

    final existingProduct =
        ModalRoute.of(context)?.settings.arguments as Event?;
    final isEdit = existingProduct != null;

    if (isEdit) {
      nameController.text = existingProduct.name;
      priceController.text = existingProduct.price.toString();
      imageController.text = existingProduct.image;
      descriptionController.text = existingProduct.description;
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
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text);
                final image = imageController.text.trim();
                final description = descriptionController.text.trim();

                if (name.isEmpty ||
                    price == null ||
                    image.isEmpty ||
                    description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required.')),
                  );
                  return;
                }

                final newProduct = Event(
                  id: isEdit
                      ? existingProduct.id
                      : DateTime.now()
                          .millisecondsSinceEpoch, // Ganti jika menggunakan ID unik
                  name: name,
                  price: price,
                  image: image,
                  description: description,
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
//~~~ Made by Riko Gunawan ~~~