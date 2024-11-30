import 'package:flutter/material.dart';

Widget buildContainerLeader(BuildContext context, String type) {
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
        mainAxisSize: MainAxisSize
            .min, // Mengatur agar konten hanya sesuai dengan ukuran minimum
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
            // Mengatur agar ListView fleksibel dan tidak menyebabkan overflow
            child: ListView.builder(
              itemCount: 5,
              shrinkWrap:
                  true, // Membuat ListView menyesuaikan ukuran kontennya
              physics:
                  const ClampingScrollPhysics(), // Membatasi scrolling ke konten yang ada
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
                        'Pengguna ${index + 1}',
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
