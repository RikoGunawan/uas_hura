import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false; // State untuk loading
  String? _errorMessage; // State untuk error message

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fungsi login (dummy)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulasi delay proses login
      await Future.delayed(const Duration(seconds: 2));

      // Dummy login success
      if (email == "user@example.com" && password == "password") {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception("Invalid email or password");
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
