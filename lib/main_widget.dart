import 'package:flutter/material.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/product_search_delegate.dart';
import 'screens/home_screen.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text('Index 1: Profile'),
    Text('Index 2: Contact Us ^_^'),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(''),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Menggunakan ProductSearchDelegate
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(productProvider),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 69, 163, 240),
              ),
              child: Text(
                'Nekoshop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTap(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTap(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Contact Us ^_^'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTap(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: _widgetOptions[_selectedIndex],
      ),
      // (Note) FAB Cart hanya muncul untuk HomeScreen
      floatingActionButton: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 20),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 69, 163, 240),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.shopping_cart, size: 25),
                ),
              ),
            )
          : null, // Tidak ada FAB untuk halaman selain HomeScreen
    );
  }
}
