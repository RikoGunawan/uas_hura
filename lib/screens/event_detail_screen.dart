import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main_widget.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late String formattedPrice;
  int quantity = 1;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '$quantity');
    formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.event.price);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
      bottomNavigationBar: BottomAppBar(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            _quantityController.text = '$quantity';
                          }
                        });
                      },
                      child: const Icon(Icons.remove, size: 9),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      controller: _quantityController,
                      style: const TextStyle(fontSize: 9),
                      onChanged: (value) {
                        quantity = int.tryParse(value) ?? 1;
                      },
                    ),
                  ),
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          quantity++;
                          _quantityController.text = '$quantity';
                        });
                      },
                      child: const Icon(Icons.add, size: 9),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final eventProvider =
                    Provider.of<EventProvider>(context, listen: false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainWidget()),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${widget.event.name} ditambahkan ke keranjang'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//~~~ Made by Riko Gunawan ~~~