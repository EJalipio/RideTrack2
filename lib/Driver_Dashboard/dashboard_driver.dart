import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/Driver_Dashboard/booked.dart';
import 'dart:io';
import 'driver_profile.dart';

class RideTrackApp extends StatefulWidget {
  final String welcomeMessage;

  const RideTrackApp({Key? key, required this.welcomeMessage})
      : super(key: key);

  @override
  _RideTrackAppState createState() => _RideTrackAppState();
}

class _RideTrackAppState extends State<RideTrackApp> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomedriverScreen(welcomeMessage: widget.welcomeMessage),
      LocationScreen(), // Define your location screen here
      ProfileScreen(), // Define your profile screen here
    ];
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onNavBarTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomedriverScreen extends StatefulWidget {
  final String welcomeMessage;

  const HomedriverScreen({Key? key, required this.welcomeMessage})
      : super(key: key);

  @override
  _HomedriverScreenState createState() => _HomedriverScreenState();
}

class _HomedriverScreenState extends State<HomedriverScreen> {
  File? _profileImage;

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage == null
                        ? const AssetImage('assets/profile.jpg')
                        : FileImage(_profileImage!) as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.welcomeMessage,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              childAspectRatio: 1.2,
              children: [
                _buildGridButton('Ride History', Icons.history, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RideHistoryScreen()),
                  );
                }),
                _buildGridButton('Booked', Icons.monetization_on, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookedTodayScreen()),
                  );
                }),
                _buildGridButton('Earnings', Icons.monetization_on, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarningsScreen()),
                  );
                }),
                _buildGridButton('Feedbacks', Icons.feedback, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                }),
                _buildGridButton('Settings', Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RouteSettings()),
                  );
                }),
                _buildGridButton('Notifications', Icons.notifications, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationListener()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: Colors.orange[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Center(child: Text('Temporary Location')),
    );
  }
}

// Profile Screen with Image Pick and Save

// Ride History Screen
class RideHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ride History')),
      body: Center(child: Text('Ride History Page')),
    );
  }
}

// Book Ride Screen

// Earnings Screen
class EarningsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Earnings')),
      body: Center(child: Text('Earnings Page')),
    );
  }
}

// Feedbacks Screen
class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedbacks')),
      body: Center(child: Text('Feedbacks Page')),
    );
  }
}

// RouteSettings Screen
class RouteSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Page')),
    );
  }
}

// Notification Screen
class NotificationListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body: Center(child: Text('Notification Page')),
    );
  }
}
