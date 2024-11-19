import 'package:flutter/material.dart';
import 'package:myapp/screens/profile_screen.dart';

import 'screens/home_screen.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Ini halaman Event')),
    // const FeedScreen(),
    const Center(child: Text('Ini halaman Hura')),
    const Center(child: Text('Ini halaman Hura Point')),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainWidgetTemplate(
      body: _pages[_currentIndex],
      currentIndex: _currentIndex,
      onTabTapped: _onTabTapped,
    );
  }
}

//---------------------------------------- Kontrol Main Widget

class MainWidgetTemplate extends StatelessWidget {
  final Widget body; // Konten layar
  final int currentIndex; // Indeks tab yang dipilih
  final Function(int) onTabTapped; // Callback untuk navigasi tab

  const MainWidgetTemplate({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}

// ----------------------------------------- AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: Stack(
        children: [
          Positioned(
            left: 20,
            top: 18,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(40, 255, 255, 255),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  // Tambahkan aksi yang diinginkan di sini
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

//-------------------------------- Bottom Navigation Bar

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50,
      shape: const CircularNotchedRectangle(),
      // notchMargin: 12.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBottomNavigationItem(Icons.home, 0),
          _buildBottomNavigationItem(Icons.event, 1),
          _buildBottomNavigationItem(Icons.forest, 2),
          _buildBottomNavigationItem(Icons.star, 3),
          _buildBottomNavigationItem(Icons.person, 4),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color.fromARGB(255, 64, 107, 65)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }
}

// //~~~ Made by Riko Gunawan ~~~
// import 'package:flutter/material.dart';
// import 'package:myapp/screens/cart_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/product_provider.dart';
// import 'providers/product_search_delegate.dart';
// import 'screens/contact_us_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/profile_screen.dart';

// class MainWidget extends StatefulWidget {
//   const MainWidget({super.key});

//   @override
//   State<MainWidget> createState() => _MainWidgetState();
// }

// class _MainWidgetState extends State<MainWidget> {
//   int _selectedIndex = 0;

//   static const List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     ProfileScreen(),
//     ContactUsScreen(),
//   ];

//   void _onItemTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 40.0,
//         title: const Text(''),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Menggunakan ProductSearchDelegate
//               showSearch(
//                 context: context,
//                 delegate: ProductSearchDelegate(productProvider),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 69, 163, 240),
//               ),
//               child: Text(
//                 'Nekoshop',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: const Text('Home'),
//               selected: _selectedIndex == 0,
//               onTap: () {
//                 _onItemTap(0);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Profile'),
//               selected: _selectedIndex == 1,
//               onTap: () {
//                 _onItemTap(1);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Contact Us ^_^'),
//               selected: _selectedIndex == 2,
//               onTap: () {
//                 _onItemTap(2);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
//         child: _widgetOptions[_selectedIndex],
//       ),
//       // (Note) FAB Cart hanya muncul untuk HomeScreen
//       floatingActionButton: _selectedIndex == 0
//           ? Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 10, 20),
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Color.fromARGB(255, 69, 163, 240),
//                 ),
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CartScreen(),
//                       ),
//                     );
//                   },
//                   backgroundColor: Colors.transparent,
//                   foregroundColor: Colors.white,
//                   child: const Icon(Icons.shopping_cart, size: 25),
//                 ),
//               ),
//             )
//           : null, // Tidak ada FAB untuk halaman selain HomeScreen
//     );
//   }
// }
