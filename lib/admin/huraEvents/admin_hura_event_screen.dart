import 'package:flutter/material.dart';
import 'package:myapp/admin/huraEvents/add_hura_event.dart';
import 'package:myapp/admin/huraEvents/edit_hura_event.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';

class AdminHuraEventScreen extends StatelessWidget {
  const AdminHuraEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Events",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // Tombol untuk menambahkan item baru
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHuraEvent(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 16, // Jarak horizontal antar Card
          runSpacing: 16, // Jarak vertikal antar Card
          alignment: WrapAlignment.center,
          children: eventProvider.events.map((event) {
            return _buildCardItem(event, context);
          }).toList(),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 24,
        width: 70,
        // Tambahkan logika di sini jika ingin mengaktifkan FloatingActionButton
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCardItem(event, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: screenWidth * 0.05, // Padding horizontal 5% dari layar
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            double scale = 1.0;

            return GestureDetector(
              onTapDown: (_) {
                setState(() {
                  scale = 1.1;
                });
              },
              onTapUp: (_) {
                setState(() {
                  scale = 1.0;
                });
              },
              onTapCancel: () {
                setState(() {
                  scale = 1.0;
                });
              },
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 200),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8, // Lebar Card 80% dari layar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                event.image,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/default.jpg',
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              right: 8,
                              child: Text(
                                event.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Positioned(
                              left: 8,
                              //right: 8,
                              top: 12,
                              bottom: 2,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit_square,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditHuraEventAdmin()),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Tampilkan dialog konfirmasi sebelum menghapus
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Konfirmasi Hapus"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menghapus event ini?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Batal"),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Hapus"),
                                            onPressed: () {
                                              // Panggil metode untuk menghapus event dari provider
                                              Provider.of<EventProvider>(
                                                      context,
                                                      listen: false)
                                                  .removeEvent(event.id);
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
