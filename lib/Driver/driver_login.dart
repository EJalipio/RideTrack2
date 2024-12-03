import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/Driver_Dashboard/dashboard_driver.dart';
import 'custom_button.dart';
import 'custom_textfield.dart';
import 'driver_register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // Loading state flag

  Future<void> _validateRideTrackApp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show the loading indicator
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userName = userDoc['name'] ?? 'User';
          final registrationDate =
              (userDoc['registrationDate'] as Timestamp).toDate();
          final currentDate = DateTime.now();
          final difference = currentDate.difference(registrationDate).inDays;

          // Welcome message logic
          String welcomeMessage = difference < 2
              ? 'Welcome $userName!'
              : 'Welcome back, $userName!';

          // Navigate to the dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RideTrackApp(welcomeMessage: welcomeMessage),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'User data not found in Firestore.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_nga_bagO-removebg-preview.png', // Main app logo
                height: 300,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/car_running.gif', // Your custom loading image
                          height: 100, // Adjust size as needed
                          width: 100,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Logging in...',
                          style: TextStyle(fontSize: 16, color: Colors.orange),
                        ),
                      ],
                    )
                  : CustomButton(
                      text: 'Login',
                      onPressed: _validateRideTrackApp,
                    ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
