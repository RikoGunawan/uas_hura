import 'package:flutter/material.dart';

import '../main_event_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Guest!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod ?',
                    style: TextStyle(
                      color: Color.fromARGB(185, 0, 0, 0),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const MainEventWidget(),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Creative Hura',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView(
                        shrinkWrap:
                            true, // Menambahkan shrinkWrap agar tidak menyebabkan konflik scroll
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scroll khusus untuk ListView
                        children: const [
                          CardWidget(),
                          SizedBox(height: 20),
                          CardWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Color.fromARGB(255, 229, 66, 37),
                    size: 30,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
