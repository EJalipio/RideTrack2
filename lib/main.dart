import 'dart:async';
import 'package:flutter/material.dart';
import 'package:practice/Passenger/passenger_login.dart';
import '../Driver/driver_login.dart';
//import '../Passenger/passenger_login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD8riErV7oInQ-3WqzoLKPqdka0VwuZDak",
      appId: "1:519515470867:android:227d3905011ae544da53e6",
      messagingSenderId: "519515470867",
      projectId: "ridetrack-846b1",
    ),
  );

  runApp(RideTrackApp());
}

class RideTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto', // Custom font if desired
      ),
      home: RideTrackHomePage(),
    );
  }
}

class RideTrackHomePage extends StatefulWidget {
  @override
  _RideTrackHomePageState createState() => _RideTrackHomePageState();
}

class _RideTrackHomePageState extends State<RideTrackHomePage> {
  bool _isBlinking = true;

  @override
  void initState() {
    super.initState();

    // Create a timer to handle the blinking effect (every 1.5 seconds for slower blinking)
    Timer.periodic(Duration(milliseconds: 1500), (timer) {
      setState(() {
        _isBlinking = !_isBlinking; // Toggle the blink state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo and Title with FadeIn Animation
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 1),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/download.png', // Replace with actual logo path
                      height: 290,
                      width: 290,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // App Description with Slide-In Animation
              AnimatedSlide(
                offset: Offset(0, 0),
                duration: Duration(seconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Join RideTrack Today: Register for Smooth Tricycle Riders Hassle-Free Dispatching!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Driver and Passenger Buttons with Bounce and Shadow Effects
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Driver Button with Slow Blink Effect
                  GestureDetector(
                    onTap: () => navigateToLoginScreen(context),
                    child: AnimatedOpacity(
                      opacity: _isBlinking ? 1.0 : 0.3, // Blink effect
                      duration: Duration(milliseconds: 10), // Slow blink speed
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 10),
                        curve: Curves.easeInOut,
                        width: 160,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_bike,
                              size: 80,
                              color: Colors.deepOrange,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  // Passenger Button with Slow Blink Effect
                  GestureDetector(
                    onTap: () => navigateToPassengerLogin(context),
                    child: AnimatedOpacity(
                      opacity: _isBlinking ? 1.0 : 0.3, // Blink effect
                      duration: Duration(milliseconds: 10), // Slow blink speed
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 10),
                        curve: Curves.easeInOut,
                        width: 160,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.blue.shade700,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Passenger',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to Driver Login Screen
  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // Navigate to Passenger Login Screen
  void navigateToPassengerLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassengerLogin()),
    );
  }
}
