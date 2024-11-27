import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController =
      TextEditingController(); // Controller untuk username
  final _firstNameController =
      TextEditingController(); // Controller untuk username
  final _lastNameController =
      TextEditingController(); // Controller untuk full name
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose(); // Dispose username controller
    _firstNameController.dispose(); // Dispose username controller
    _lastNameController.dispose(); // Dispose full name controller
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      // Melakukan sign-up
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'username': _usernameController.text.trim(),
        },
      );

      if (response.user != null) {
        // Registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // Jika tidak ada user, anggap ada kesalahan
        throw Exception('Registrasi gagal, silakan coba lagi.');
      }
    } catch (error) {
      // Tangani kesalahan yang tidak terduga
      setState(() {
        _errorMessage = 'Terjadi kesalahan: ${error.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false; // Mengubah status loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar')),
      body: SingleChildScrollView(
        // Menambahkan SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  _usernameController, // Tambahkan TextField untuk username
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  _firstNameController, // Tambahkan TextField untuk full name
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:
                  _lastNameController, // Tambahkan TextField untuk full name
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Daftar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
