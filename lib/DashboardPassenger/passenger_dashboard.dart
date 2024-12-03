import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'booking_screen.dart';
import 'pass_profile.dart';

class HomeScreen extends StatefulWidget {
  final String welcomeMessage;

  const HomeScreen({super.key, required this.welcomeMessage});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Current selected index

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      PassengerHomeScreen(welcomeMessage: widget.welcomeMessage),
      PassLocationScreen(),
      PassprofileScreen(welcomeMessage: widget.welcomeMessage),
    ];
  }

  // Update the current index when a navigation item is tapped
  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[
          _currentIndex], // Display the current screen based on selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onNavBarTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home (Homedriver) Screen
class PassengerHomeScreen extends StatefulWidget {
  final String welcomeMessage;

  const PassengerHomeScreen({super.key, required this.welcomeMessage});

  @override
  _PassengerHomeScreenState createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  File? _profileImage;

  // Method to pick an image from gallery
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
        title: const Text('Passenger Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage == null
                        ? AssetImage('assets/profile.jpg') // Default image
                        : FileImage(_profileImage!)
                            as ImageProvider<Object>, // Proper casting
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.welcomeMessage, // Display dynamic welcome message
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Dashboard Grid Buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              childAspectRatio: 1.2, // Adjusts the size of each button
              children: [
                _buildGridButton('Ride History', Icons.history, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassHistoryScreen()),
                  );
                }),
                _buildGridButton('Booked', Icons.book_online, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookPassScreen()),
                  );
                }),
                _buildGridButton('Earnings', Icons.monetization_on, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassEarningsScreen()),
                  );
                }),
                _buildGridButton('Feedbacks', Icons.feedback, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassFeedbackScreen()),
                  );
                }),
                _buildGridButton('Settings', Icons.settings, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassengerSettings()),
                  );
                }),
                _buildGridButton('Notifications', Icons.notifications, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PassNotification()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Grid Button Widget for the dashboard options
  Widget _buildGridButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: Colors.orange[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Location Screen
class PassLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Center(
        child: Text(
          'This is the Location Screen.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Ride History Screen
class PassHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ride History')),
      body: Center(child: Text('Wanna Ride History Page')),
    );
  }
}

// Book Ride Screen

// Earnings Screen
class PassEarningsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Earnings')),
      body: Center(child: Text('PassengerEarnings Page')),
    );
  }
}

// Feedbacks Screen
class PassFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedbacks')),
      body: Center(child: Text('Passenger Feedbacks Page')),
    );
  }
}

// RouteSettings Screen
class PassengerSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Passenger Settings Page')),
    );
  }
}

// Notification Screen
class PassNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body: Center(child: Text('Passenger Notification Page')),
    );
  }
}
