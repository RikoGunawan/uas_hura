import 'dart:async';
import 'dart:collection';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/event.dart';
import '../screens/huraEvents/event_detail_screen.dart';

class EventProvider extends ChangeNotifier {
//-------------------------------------------- List Event
  final List<Event> _events = [
    Event(
      id: 1,
      name: 'TERRAQUEST',
      price: 350000,
      image: 'assets/event_terraquest.jpg',
      description:
          'Lomba Lintas Alam Terraquest memanggil para petualang untuk kembali dengan keindahan alam Tahura, melakukan pembersihan sungai, menanam pohon',
      eventDate: DateTime(2024, 12, 5, 10, 00), // 2024 Nov 23 10:46
    ),
    Event(
      id: 2,
      name: 'Briony Journey',
      price: 130000,
      image: 'assets/event_brionyjourney.jpg',
      description:
          'Flower Arrangement & Creative Journaling. Mari temukan harmoni antara alam, seni, dan kreativitas di tengah indahnya hutan Tahura!',
      eventDate: DateTime(2024, 12, 5, 13, 00),
    ),
    Event(
      id: 3,
      name: 'Urban To Forest ECO RUN',
      price: 5000,
      image: 'assets/event_urban.jpg',
      description:
          'Fun Run dari perkotaan menuju ke Tahura yang akan membantu kamu untuk menenangkan diri sejenak dari hiruk pikuk kerasnya kota.',
      eventDate: DateTime(2024, 11, 29, 08, 00),
    ),
    Event(
      id: 4,
      name: 'Sejalan Bareng 2024',
      price: 149000,
      image: 'assets/event_sejalanbareng.jpg',
      description:
          'Mengajak peserta jalan santai 3 KM sekaligus berkontribusi untuk menyantuni Anak Yatim dan Saudara di Palestina. Setiap langkah kecil yang kamu tempuh, sangat bernilai besar bagi mereka. ',
      eventDate: DateTime(2024, 12, 07, 07, 00),
    ),
    Event(
      id: 5,
      name: 'Bincang Forest #23',
      price: 0,
      image: 'assets/event_bincangforest.jpg',
      description:
          'Dalam memperingati Hari Habitat Sedunia, FIOF mengajak sobat bumi untuk hadir dalam Bincang Forest Episode 23! “Eksplorasi Keanekaragaman Hayati dan Hewani di Tahura Djuanda untuk Masa Depan Bumi” Kami berkolaborasi dengan @tahuradjuanda.official untuk membahas Harmoni Manusia dan Alam di Tahura Ir. H. Djuanda bersama Bapak Diki, A.Md. (Pengendali Ekosistem Hutan Tahura Ir. H. Djuanda) sebagai pembicara!',
      eventDate:
          DateTime(2024, 12, 07, 10, 00), // Tanggal acara yang ditentukan
    ),
    Event(
      id: 6,
      name: 'Festival Bala-Bala & Kopi',
      price: 0,
      image: 'assets/event_balabala.jpg',
      description:
          'Pasar pasisian leuweung Perhutanan Sosial akan dilaksanakan di Tahura Ir. H. Djuanda pada Minggu, 18 Agustus 2024 dalam rangka memeriahkan HUT Republik Indonesia dan HUT Jawa Barat. Kegiatan ini akan diramaikan oleh produk-produk hasil hutan yang berasal dari Jawa Barat serta hiburan yang seru loh. Sobat Tahura yang tertarik untuk berpartisipasi mengisi booth di acara tersebut dapat melakukan pendaftaran melalui link tersebut: https://bit.ly/KurasiPengisiStandPasleuwPS_Tahura atau bisa klik link yang ada di bio kami yah.',
      eventDate: DateTime(2024, 12, 5, 15, 00),
    ),
    // Tambahkan produk lain sesuai kebutuhan
  ];

  // -------------------------------------------- Search Event
  List<Event> _filteredEvents = [];
  List<Event> get events => _filteredEvents.isEmpty ? _events : _filteredEvents;

  void searchEvent(String query) {
    _filteredEvents = query.isEmpty
        ? _events
        : _events
            .where((event) =>
                event.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    notifyListeners();
  }

  // -------------------------------------------- Countdown + Notifikasi Event
  final List<Event> _eventsWithNotification = [];
  List<Event> get eventsWithNotification => _eventsWithNotification;

  final Queue<Event> _notificationQueue = Queue();
  bool _isShowingNotification = false;
  Timer? _notificationDelayTimer;
  Timer? countdownTimer;
  static const Duration notificationDelay = Duration(seconds: 5);

  EventProvider() {
    startCountdown();
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      for (var event in _events) {
        final duration = _calculateEventDuration(event);

        if (duration == null || duration.isNegative) {
          _removeEventFromNotification(event);
        } else if (duration.inDays <= 1) {
          _addEventToNotification(event);
        }
      }
      notifyListeners();
    });
  }

  Duration? _calculateEventDuration(Event event) {
    return event.eventDate.difference(DateTime.now());
  }

  void _addEventToNotification(Event event) {
    if (!_eventsWithNotification.contains(event)) {
      _eventsWithNotification.add(event);
      _queueNotification(event);
      notifyListeners();
    }
  }

  void _removeEventFromNotification(Event event) {
    if (_eventsWithNotification.contains(event)) {
      _eventsWithNotification.remove(event);
      notifyListeners();
    }
  }

  void _queueNotification(Event event) {
    if (!_notificationQueue.contains(event) && _isEventUpcoming(event)) {
      _notificationQueue.add(event);
      _processNotificationQueue();
    }
  }

  void _processNotificationQueue() {
    if (!_isShowingNotification && _notificationQueue.isNotEmpty) {
      final event = _notificationQueue.removeFirst();

      if (!_isEventUpcoming(event)) {
        return; // Skip expired events
      }

      _isShowingNotification = true;
      _showEventNotification(event);

      _notificationDelayTimer = Timer(notificationDelay, () {
        _isShowingNotification = false;
        _processNotificationQueue();
      });
    }
  }

  bool _isEventUpcoming(Event event) {
    final duration = _calculateEventDuration(event);
    return duration != null && !duration.isNegative;
  }

  void _showEventNotification(Event event) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final duration = _calculateEventDuration(event);
    if (duration == null || duration.isNegative) return;

    ElegantNotification(
      icon: const Icon(Icons.access_alarm, color: Colors.orange),
      progressIndicatorColor: Colors.orange,
      width: MediaQuery.of(context).size.width * 0.85,
      toastDuration: const Duration(seconds: 5),
      isDismissable: false,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      title: Text(
        event.name,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      description: Text(
        'Event live dalam ${duration.inHours} jam!',
        style: const TextStyle(fontSize: 9),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onDismiss: () {
        _isShowingNotification = false;
        _processNotificationQueue();
      },
      onNotificationPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
    ).show(context);
  }

  // CRUD Methods
  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void editEvent(Event event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  void removeEvent(Event event) {
    _events.remove(event);
    _removeEventFromNotification(event);
    notifyListeners();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    _notificationDelayTimer?.cancel();
    super.dispose();
  }
}
