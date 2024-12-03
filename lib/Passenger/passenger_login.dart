import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice/DashboardPassenger/passenger_dashboard.dart';
import 'package:practice/Passenger/pass_button.dart';
import 'package:practice/Passenger/pass_textfield.dart';
import 'package:practice/Passenger/passenger_register.dart';

class PassengerLogin extends StatefulWidget {
  const PassengerLogin({Key? key}) : super(key: key);

  @override
  _PassengerLoginState createState() => _PassengerLoginState();
}

class _PassengerLoginState extends State<PassengerLogin>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation for logo scaling
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _validateHomeScreen() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
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
            .collection('userspassenger')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final userName = userDoc['name'] ?? 'User';
          final registrationDate =
              (userDoc['registrationDate'] as Timestamp).toDate();
          final currentDate = DateTime.now();
          final difference = currentDate.difference(registrationDate).inDays;

          String welcomeMessage = difference < 2
              ? 'Welcome $userName!'
              : 'Welcome back, $userName!';

          setState(() {
            _isLoading = false;
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(welcomeMessage: welcomeMessage),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'User data not found in Firestore.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bj.png',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Transparent animated logo without shadow
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      'assets/logo_nga_bagO-removebg-preview.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomField(
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
                              'assets/Animation - 1732915608270.gif',
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Logging in...',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.orange),
                            ),
                          ],
                        )
                      : CusButton(
                          text: 'Login',
                          onPressed: _validateHomeScreen,
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
                        MaterialPageRoute(builder: (_) => PassengerRegister()),
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
        ],
      ),
    );
  }
}
