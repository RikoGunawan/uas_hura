import 'package:flutter/material.dart';

Widget buildContainerLeader(BuildContext context, String type) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      // Menggunakan MediaQuery untuk mendapatkan ukuran layar
      width: MediaQuery.of(context).size.width * 0.85, // 90% dari lebar layar
      // Menggunakan tinggi yang fleksibel
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.5, // Maksimal 50% dari tinggi layar
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .start, // Mengatur agar konten tidak terlalu ke tengah
        children: [
          Text(
            type,
            style: const TextStyle(
              fontSize: 16,
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
                            style: const TextStyle(fontSize: 12),
                            'Pengguna ${index + 1}'),
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
