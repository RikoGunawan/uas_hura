import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_screen.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final ProductProvider provider;

  ProductSearchDelegate(this.provider);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        toolbarHeight: 40.0,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Membersihkan input pencarian
          provider.searchProduct(''); // Reset pencarian dengan query kosong
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Menutup layar pencarian
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    provider.searchProduct(query);

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.products.isEmpty) {
          return const Center(child: Text('No products found'));
        }
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('Price: ${product.price}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(product: product),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    provider.searchProduct(query);

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.products.isEmpty) {
          return const Center(child: Text('No suggestions available'));
        }
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return ListTile(
              title: Text(product.name),
              onTap: () {
                query = product.name;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
