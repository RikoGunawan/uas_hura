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
          Text(
            type, // Menampilkan judul yang diterima dari parameter
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          LinearProgressIndicator(
            value: progress, // Menampilkan progress bar dengan value
            backgroundColor: Colors.grey[400],
            color: Colors.blue,
            minHeight: 5.0,
          ),
          const SizedBox(height: 16.0),
          Flexible(
            // Menjaga agar ListView fleksibel dan menghindari overflow
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
                      Text(
                        'Quest ${index + 1}', // Menampilkan nama quest
                        style: const TextStyle(fontSize: 12),
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
