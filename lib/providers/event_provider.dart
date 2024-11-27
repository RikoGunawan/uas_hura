import 'dart:async';
import 'dart:collection';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
//~~~ Made by Riko Gunawan ~~~
// import '../models/cart_item.dart';
import '../main.dart';
import '../models/event.dart';
import '../screens/huraEvents/event_detail_screen.dart';

class EventProvider extends ChangeNotifier {
//-------------------------------------------- List Event
  final List<Event> _events = [
    Event(
      id: 1,
      name: 'Minecraft Papercraft Biome',
      price: 999999,
      image: 'mc_papercraft.jpg',
      description:
          'Minecraft Papercraft merupakan sebuah produk miniatur yang terbuat dari rangkaian kertas berwarna khusus dan magnet yang dapat kamu gabungkan menjadi sebuah bangunan atau biome yang kamu inginkan seperti lego! Kenapa tidak mencoba membelinya kalau kamu punya uang?',
      eventDate: DateTime(2024, 11, 27, 11, 52), // 2024 Nov 23 10:46
    ),
    Event(
      id: 2,
      name: 'Minecraft Bedrock Edition',
      price: 55000,
      image: 'mc_game.jpg',
      description:
          'Minecraft game bisa kamu beli dengan harga spesial! Bedrock edition version',
      eventDate: DateTime(2024, 11, 26, 11, 52),
    ),
    Event(
      id: 3,
      name: 'Headset Creeper Minecraft',
      price: 77000,
      image: 'mc_headset.jpg',
      description: 'Melengkapi kebutuhan gamingmu!',
      eventDate: DateTime(2024, 11, 26, 11, 55),
    ),
    Event(
      id: 4,
      name: 'Minecraft Chicken Egg Cup',
      price: 49999,
      image: 'mc_egg_cup.jpg',
      description:
          'Tempat menaruh 1 telur dengan style minecraft yang sangat lucu',
      eventDate: DateTime(2024, 11, 23, 11, 56),
    ),
    Event(
      id: 5,
      name: 'Torch Light Minecraft',
      price: 59999,
      image: 'mc_torch_light.jpg',
      description: 'Lampu yang bukan sembarang lampu..',
      eventDate: DateTime(2024, 11, 22, 10, 0),
    ),
    Event(
      id: 6,
      name: 'Steven He',
      price: 911,
      image: 'stevenhe.jpg',
      description: 'EMOTIONAL DAMAGE Asian Parent',
      eventDate: DateTime(2024, 11, 23, 10, 0), // Tanggal acara yang ditentukan
    ),
    // Tambahkan produk lain sesuai kebutuhan
  ];

//------------------------------- Search Event (not used)

  List<Event> _filteredEvents = []; // Daftar produk yang difilter
  List<Event> get events => _filteredEvents.isEmpty ? _events : _filteredEvents;
  void searchEvent(String query) {
    if (query.isEmpty) {
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events
          .where(
              (event) => event.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

// ------------------------------- Countdown + Notifikasi Event
  final List<Event> _eventsWithNotification = [];
  List<Event> get eventsWithNotification => _eventsWithNotification;

  // Queue untuk menyimpan event yang belum ditampilkan notifikasinya
  final Queue<Event> _notificationQueue = Queue();

  // Flag untuk mengecek apakah sedang menampilkan notifikasi
  bool _isShowingNotification = false;

  // Tambahkan variabel untuk mengatur jeda antar notifikasi
  Timer? _notificationDelayTimer;
  static const Duration notificationDelay = Duration(seconds: 5);

  Duration? countdownDuration;
  Timer? countdownTimer;

  EventProvider() {
    startCountdown();
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var event in _events.toList()) {
        final duration = event.eventDate.difference(DateTime.now());

        if (duration.isNegative) {
          // Hapus event dari daftar notifikasi
          _removeEventFromNotification(event);
        } else if (duration.inDays <= 1) {
          countdownDuration = duration;
          _addEventToNotification(event);
        }
      }
      notifyListeners();
    });
  }

  void _addEventToNotification(Event event) {
    final duration = event.eventDate.difference(DateTime.now());
    if (duration.isNegative) {
      _removeEventFromNotification(event);
      return;
    }

    if (!_eventsWithNotification.contains(event)) {
      _eventsWithNotification.add(event);
      _queueNotification(event);
      notifyListeners();
    }
  }

  void _removeEventFromNotification(Event event) {
    _eventsWithNotification.remove(event);
    notifyListeners();
  }

  void _queueNotification(Event event) {
    // Cek apakah event sudah ada di queue
    if (!_notificationQueue.contains(event)) {
      _notificationQueue.add(event);
      _processNotificationQueue();
    }
  }

  void _processNotificationQueue() {
    if (!_isShowingNotification && _notificationQueue.isNotEmpty) {
      Event event = _notificationQueue.first;

      // Pastikan event belum lewat sebelum menampilkan notifikasi
      if (event.eventDate.isBefore(DateTime.now())) {
        _notificationQueue.removeFirst();
        return; // Jangan proses event yang sudah lewat
      }

      _isShowingNotification = true;
      _notificationQueue.removeFirst();

      // Tampilkan notifikasi
      _showEventNotification(event);

      // Set timer untuk jeda notifikasi
      _notificationDelayTimer = Timer(notificationDelay, () {
        _isShowingNotification = false;
        _processNotificationQueue();
      });
    }
  }

  void _showEventNotification(Event event) {
    final screenWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    if (navigatorKey.currentContext != null) {
      // Hitung ulang durasi saat notifikasi ditampilkan
      final duration = event.eventDate.difference(DateTime.now());

      ElegantNotification(
        icon: const Icon(
          Icons.access_alarm,
          color: Colors.orange,
        ),
        progressIndicatorColor: Colors.orange,
        width: screenWidth * 0.85,
        toastDuration: const Duration(seconds: 5),
        isDismissable: false,
        position: Alignment.topCenter,
        animation: AnimationType.fromTop,
        title: Text(
          event.name,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          _truncateDescription(
            'Event live dalam ${duration.inHours} jam!',
          ),
          style: const TextStyle(
            fontSize: 9,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onDismiss: () {
          // Batalkan timer sebelumnya jika ada
          _notificationDelayTimer?.cancel();

          // Reset status notifikasi
          _isShowingNotification = false;
          _processNotificationQueue();
        },
        onNotificationPressed: () {
          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: event)));
        },
      ).show(navigatorKey.currentContext!);
    }
  }

  // Fungsi untuk memotong deskripsi
  String _truncateDescription(String description, {int maxLength = 70}) {
    if (description.length <= maxLength) {
      return description;
    }
    return '${description.substring(0, maxLength)}...';
  }

  // Tambahan method untuk mendapatkan durasi event
  Duration? getEventCountdownDuration(Event event) {
    return event.eventDate.difference(DateTime.now());
  }

  // Metode CRUD untuk event (tidak diakses user)
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void editEvent(Event event) {
    final index = _events.indexWhere((element) => element.id == event.id);
    _events[index] = event;
    notifyListeners();
  }

  void removeEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  // Pastikan membersihkan timer saat provider di dispose
  @override
  void dispose() {
    countdownTimer?.cancel();
    _notificationDelayTimer?.cancel();
    super.dispose();
  }
}
