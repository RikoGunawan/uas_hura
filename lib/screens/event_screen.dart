import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'event_detail_screen.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 16, // Jarak horizontal antar Card
          runSpacing: 0, // Jarak vertikal antar Card
          alignment: WrapAlignment.center,
          children: eventProvider.events.map((event) {
            return _buildCardItem(event, context);
          }).toList(),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 24,
        width: 70,
        child: FloatingActionButton.extended(
          onPressed: () => _openWhatsApp(context),
          backgroundColor: const Color(0xFFE54125),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          label: const Text(
            "Contact us!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCardItem(Event event, BuildContext context) {
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

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                );
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
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              right: 8,
                              top: 8,
                              child: Text(
                                event.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

  void _openWhatsApp(BuildContext context) async {
    const phoneNumber = '+6285156613178';
    const message = 'Hello! I want to know more about your events.';
    final whatsappUrl = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening WhatsApp')),
      );
    }
  }
}
