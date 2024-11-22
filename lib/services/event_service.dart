// event_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';

class EventService {
  final SupabaseClient client;

  EventService(this.client);

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await client.from('events').select();

      // Memeriksa apakah respons tidak kosong
      if (response.isEmpty) {
        throw Exception('No events found.');
      }

      return response.map((json) => Event.fromJson(json)).toList();
    } catch (err) {
      throw Exception('Failed to load events: ${err.toString()}');
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      final response = await client.from('events').insert(event.toJson());

      // Memeriksa apakah respons tidak kosong
      if (response.isEmpty) {
        throw Exception('Failed to add event: No response from server.');
      }
    } catch (err) {
      throw Exception('Failed to add event: ${err.toString()}');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      final response =
          await client.from('events').update(event.toJson()).eq('id', event.id);

      // Memeriksa apakah respons tidak kosong
      if (response.isEmpty) {
        throw Exception('Failed to update event: No response from server.');
      }
    } catch (err) {
      throw Exception('Failed to update event: ${err.toString()}');
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      final response = await client.from('events').delete().eq('id', id);

      // Memeriksa apakah respons tidak kosong
      if (response.isEmpty) {
        throw Exception('Failed to delete event: No response from server.');
      }
    } catch (err) {
      throw Exception('Failed to delete event: ${err.toString()}');
    }
  }
}
