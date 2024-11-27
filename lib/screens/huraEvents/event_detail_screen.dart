import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../providers/event_provider.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late String formattedPrice;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _initializeEventDetails();
  }

  void _initializeEventDetails() {
    _quantityController = TextEditingController(text: '1');
    formattedPrice = _formatPrice(widget.event.price);
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  String _formatCountdownDuration(Duration duration) {
    if (duration.isNegative) {
      return "Event sudah berlangsung";
    }
    return '${duration.inDays} hari '
        '${duration.inHours.remainder(24)}:'
        '${duration.inMinutes.remainder(60)}:'
        '${duration.inSeconds.remainder(60)}';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final countdownDuration = widget.event.eventDate.difference(DateTime.now());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                widget.event.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20.0, 24, 24),
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 9,
                            color: countdownDuration.inDays <= 1
                                ? Colors.red
                                : AppColors.secondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _formatCountdownDuration(countdownDuration),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: countdownDuration.inDays <= 1
                                  ? Colors.red
                                  : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.event.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.event.description,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//~~~ Made by Riko Gunawan ~~~