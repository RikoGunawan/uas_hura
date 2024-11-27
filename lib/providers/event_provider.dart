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
      name: 'TERRAQUEST',
      price: 350000,
      image: 'mc_papercraft.jpg',
      description:
          'Lomba Lintas Alam Terraquest memanggil para petualang untuk kembali dengan keindahan alam Tahura, melakukan pembersihan sungai, menanam pohon',
      eventDate: DateTime(2024, 12, 14, 08, 00), // 2024 Nov 23 10:46
    ),
    Event(
      id: 2,
      name: 'Briony Journey',
      price: 130000,
      image: 'mc_game.jpg',
      description:
          'Flower Arrangement & Creative Journaling. Mari temukan harmoni antara alam, seni, dan kreativitas di tengah indahnya hutan Tahura!',
      eventDate: DateTime(2024, 12, 15, 10, 00),
    ),
    Event(
      id: 3,
      name: 'Urban To Forest ECO RUN',
      price: 5000,
      image: 'mc_headset.jpg',
      description:
          'Fun Run dari perkotaan menuju ke Tahura yang akan membantu kamu untuk menenangkan diri sejenak dari hiruk pikuk kerasnya kota.',
      eventDate: DateTime(2024, 11, 10, 08, 00),
    ),
    Event(
      id: 4,
      name: 'Sejalan Bareng 2024',
      price: 149000,
      image: 'mc_egg_cup.jpg',
      description:
          'Mengajak peserta jalan santai 3 KM sekaligus berkontribusi untuk menyantuni Anak Yatim dan Saudara di Palestina. Setiap langkah kecil yang kamu tempuh, sangat bernilai besar bagi mereka. ',
      eventDate: DateTime(2024, 10, 13, 09, 00),
    ),
    Event(
      id: 5,
      name: 'Bincang Forest #23',
      price: 0,
      image: 'stevenhe.jpg',
      description:
          'Dalam memperingati Hari Habitat Sedunia, FIOF mengajak sobat bumi untuk hadir dalam Bincang Forest Episode 23! “Eksplorasi Keanekaragaman Hayati dan Hewani di Tahura Djuanda untuk Masa Depan Bumi” Kami berkolaborasi dengan @tahuradjuanda.official untuk membahas Harmoni Manusia dan Alam di Tahura Ir. H. Djuanda bersama Bapak Diki, A.Md. (Pengendali Ekosistem Hutan Tahura Ir. H. Djuanda) sebagai pembicara!',
      eventDate:
          DateTime(2024, 10, 06, 10, 00), // Tanggal acara yang ditentukan
    ),
    Event(
      id: 6,
      name: 'Festival Bala-Bala & Kopi',
      price: 0,
      image: 'mc_torch_light.jpg',
      description:
          'Pasar pasisian leuweung Perhutanan Sosial akan dilaksanakan di Tahura Ir. H. Djuanda pada Minggu, 18 Agustus 2024 dalam rangka memeriahkan HUT Republik Indonesia dan HUT Jawa Barat. Kegiatan ini akan diramaikan oleh produk-produk hasil hutan yang berasal dari Jawa Barat serta hiburan yang seru loh. Sobat Tahura yang tertarik untuk berpartisipasi mengisi booth di acara tersebut dapat melakukan pendaftaran melalui link tersebut: https://bit.ly/KurasiPengisiStandPasleuwPS_Tahura atau bisa klik link yang ada di bio kami yah.',
      eventDate: DateTime(2024, 08, 18, 08, 00),
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
