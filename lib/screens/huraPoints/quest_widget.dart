import 'package:flutter/material.dart';

Widget buildContainerQuest(BuildContext context, String type, double progress) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.85, // 90% dari lebar layar
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.5, // Maksimal 50% dari tinggi layar
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Mengatur ukuran minimum
        children: [
          const Text(
            'Hura Point',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                            style: TextStyle(fontSize: 12),
                            'Quest ${index + 1}'), // Menampilkan nama quest
                      ],
                    ),
                    const SizedBox(height: 8.0), // Gap between players
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
