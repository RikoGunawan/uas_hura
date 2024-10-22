import 'package:flutter/material.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/screens/manage_product_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nekoshop by Riko'),
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
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: _widgetOptions[_selectedIndex],
      ),
      // (Note) FAB Cart hanya muncul untuk HomeScreen
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              child: const Icon(Icons.shopping_cart),
            )
          : null, // Tidak ada FAB untuk halaman selain HomeScreen
    );
  }
}
