import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  SupabaseClient supabase = Supabase.instance.client;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Login function
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Login berhasil
        return true;
      }
    } on AuthException catch (error) {
      _errorMessage = error.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return false;
  }

  // Mendapatkan role user
  Future<String?> getUserRole() async {
    final user = supabase.auth.currentUser;
    return user?.userMetadata?['role'];
  }

  // Logout function
  Future<void> logout() async {
    await supabase.auth.signOut();
    notifyListeners();
  }
}
