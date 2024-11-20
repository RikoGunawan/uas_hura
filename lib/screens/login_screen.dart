import 'package:flutter/material.dart';
import 'package:myapp/main_widget.dart';

import '../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.85,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Welcome Text (Judul)
                  const Text(
                    'Welcome to Tahura!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextFormField(
                    decoration: InputDecoration(
                      // Warna putih
                      hintText: 'Email Address',
                      hintStyle:
                          const TextStyle(fontSize: 12), // Ukuran lebih kecil
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Bulatan lebih kecil
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, // Menyesuaikan jarak vertikal
                        horizontal: 12, // Menyesuaikan jarak horizontal
                      ),
                      isDense: true, // Memastikan input field lebih kompak
                    ),
                    style: const TextStyle(
                        fontSize: 12), // Ukuran teks lebih kecil
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(
                    height: 9,
                  ),

                  // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                      ), // Ukuran lebih kecil
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Bulatan lebih kecil
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, // Menyesuaikan jarak vertikal
                        horizontal: 12, // Menyesuaikan jarak horizontal
                      ),
                      isDense: true, // Memastikan input field lebih kompak
                    ),
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 8), // Hanya memberi jarak setelah form

                  // Remember Me
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      const Text(
                        'Remember Me',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainWidget(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Failed')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Bulatan lebih kecil
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // Add forgot password logic
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 10, // Ukuran lebih kecil
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
