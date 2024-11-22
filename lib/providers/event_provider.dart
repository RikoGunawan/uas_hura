import 'dart:async';
import 'dart:collection';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
//~~~ Made by Riko Gunawan ~~~
// import '../models/cart_item.dart';
import '../main.dart';
import '../models/event.dart';
import '../screens/event_detail_screen.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService;

  // List untuk menyimpan events
  List<Event> _events = [];
  List<Event> get events => _filteredEvents.isEmpty ? _events : _filteredEvents;

  // Constructor
  EventProvider(this._eventService) {
    // Inisialisasi dengan memuat events dari database
    fetchEvents();
    startCountdown();
  }

  // Method untuk mengambil events dari database
  Future<void> fetchEvents() async {
    try {
      _events = await _eventService.fetchEvents();
      notifyListeners();
    } catch (e) {
      // Handle error, misalnya dengan menampilkan snackbar atau log
      print('Error fetching events: $e');
    }
  }

  // Method CRUD yang dimodifikasi untuk menggunakan EventService
  Future<void> addEvent(Event event) async {
    // Logika untuk menambahkan event ke database
    // Misalnya, menggunakan Supabase
    _events.add(event);
    notifyListeners();
  }

  Future<void> editEvent(Event event) async {
    // Logika untuk memperbarui event di database
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(int id) async {
    // Logika untuk menghapus event dari database
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }

  // Method pencarian event
  List<Event> _filteredEvents = [];
  void searchEvent(String query) {
    if (query.isEmpty) {
      _filteredEvents = _events;
    } else {
      _filteredEvents = _events
          .where(
              (event) => event.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

// ------------------------------- Countdown + Notifikasi Event
  List<Event> _eventsWithNotification = [];
  List<Event> get eventsWithNotification => _eventsWithNotification;

  // Queue untuk menyimpan event yang belum ditampilkan notifikasinya
  Queue<Event> _notificationQueue = Queue();

  // Flag untuk mengecek apakah sedang menampilkan notifikasi
  bool _isShowingNotification = false;

  // Tambahkan variabel untuk mengatur jeda antar notifikasi
  Timer? _notificationDelayTimer;
  static const Duration NOTIFICATION_DELAY = Duration(seconds: 5);

  Duration? countdownDuration;
  Timer? countdownTimer;

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var event in _events) {
        final duration = event.eventDate.difference(DateTime.now());

        // Update countdownDuration untuk event terdekat
        if (duration.inDays <= 1) {
          countdownDuration = duration;
          _addEventToNotification(event);
        } else if (duration.isNegative) {
          _removeEventFromNotification(event);
        }
      }
      notifyListeners();
    });
  }

  void _addEventToNotification(Event event) {
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
    // Jika tidak sedang menampilkan notifikasi dan queue tidak kosong
    if (!_isShowingNotification && _notificationQueue.isNotEmpty) {
      _isShowingNotification = true;
      Event event = _notificationQueue.removeFirst();

      // Tampilkan notifikasi
      _showEventNotification(event);

      // Set timer untuk reset status notifikasi
      _notificationDelayTimer = Timer(NOTIFICATION_DELAY, () {
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

  // Pastikan membersihkan timer saat provider di dispose
  @override
  void dispose() {
    countdownTimer?.cancel();
    _notificationDelayTimer?.cancel();
    super.dispose();
  }
}
