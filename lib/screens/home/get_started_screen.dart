import 'package:flutter/material.dart';
import 'package:myapp/screens/home/login_screen.dart';
import 'package:myapp/screens/home/register_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image filling the entire screen
          ClipRRect(
            borderRadius:
                BorderRadius.circular(0), // No rounding to fill the screen
            child: Image.asset(
              'assets/tahura.jpg',
              height: double.infinity, // Full height
              width: double.infinity, // Full width
              fit: BoxFit.cover, // Cover the entire area
            ),
          ),
          // Positioned overlay with text
          Positioned(
            top: 50, // Position the title near the top
            left: 0,
            right: 0,
            child: Text(
              'TAHURA',
              textAlign: TextAlign.center, // Center the text
              style: const TextStyle(
                fontSize: 40, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for better contrast
                shadows: [
                  Shadow(
                    blurRadius: 10.0, // Blur radius of the shadow
                    color: Colors.black54, // Color of the shadow
                    offset: Offset(2.0, 2.0), // Offset of the shadow
                  ),
                ],
              ),
            ),
          ),
          // Explore text at the bottom left
          Positioned(
            top: 330, // Position the text near the bottom
            left: 24, // Position the text from the left
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: const [
                Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
                Text(
                  'the Nature!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
              ],
            ),
          ),
          // Container for buttons at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200, // Fixed height for the button container
              width: double.infinity, // Full width of the screen
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30)), // Rounded top corners
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center buttons vertically
                children: [
                  _buildButtonLogin(
                    text: 'Login',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildButtonNew(
                    text: 'Create New Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonLogin(
      {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: 400, // Set a fixed width for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded button corners
          ),
          minimumSize:
              const Size(double.infinity, 48), // Full height for buttons
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildButtonNew(
      {required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: 400, // Set a fixed width for the button
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
          side: const BorderSide(
            color: Colors.black, // Border color
            width: 2, // Border width
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded button corners
          ),
          minimumSize:
              const Size(double.infinity, 48), // Full height for buttons
        ),
        child: Text(
          text,
          style:
              const TextStyle(fontSize: 16, color: Colors.black), // Text color
        ),
      ),
    );
  }
}
