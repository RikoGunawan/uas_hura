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
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment:
        //     CrossAxisAlignment.start, // Konten tidak terlalu ke tengah
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
          Flexible(
            child: ListView.builder(
              shrinkWrap: true, // Menyesuaikan tinggi dengan konten
              physics: const ClampingScrollPhysics(), // Membatasi scrolling
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  0.8 *
                                  progress, // Sesuai progress (disesuaikan ke 80% dari lebar layar)
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
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
