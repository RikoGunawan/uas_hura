import 'package:flutter/material.dart';

Widget buildContainerReward(
    BuildContext context, String type, double progress) {
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
        mainAxisAlignment: MainAxisAlignment
            .start, // Mengatur agar konten tidak terlalu ke tengah
        children: [
          Text(
            type,
            style: const TextStyle(
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
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 10.0, // Tinggi garis putih
                                decoration: BoxDecoration(
                                  color: Colors.white, // Garis putih
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                              Container(
                                height: 10.0, // Tinggi progress bar
                                width: MediaQuery.of(context).size.width *
                                    0.9 *
                                    progress, // Sesuai progress
                                decoration: BoxDecoration(
                                  color: Colors.grey, // Warna progress
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ],
                          ),
                        ),
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
