import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../DashboardPassenger/booking_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  String? _driverId;

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('driver_profiles/$fileName');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  // Save profile to Firestore
  Future<void> _saveProfile() async {
    String name = _nameController.text.trim();
    String plateNumber = _plateNumberController.text.trim();
    String contactNumber = _contactNumberController.text.trim();

    if (name.isEmpty || plateNumber.isEmpty || contactNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    if (_imageFile != null) {
      _uploadedImageUrl = await _uploadImage(_imageFile!);
    }

    try {
      DocumentReference driverRef = await _firestore.collection('drivers').add({
        'name': name,
        'plateNumber': plateNumber,
        'contactNumber': contactNumber,
        'profileImage': _uploadedImageUrl ?? '',
        'rating': 3.5,
        'isOnline': true, // Automatically mark driver as online
      });

      _driverId = driverRef.id;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Profile saved successfully! You are now online.')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookPassScreen()),
      );
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile.')),
      );
    }
  }

  // Mark the driver as online
  Future<void> _markDriverOnline() async {
    if (_driverId != null) {
      try {
        await _firestore.collection('drivers').doc(_driverId).update({
          'isOnline': true,
        });
        print('Driver is online.');
      } catch (e) {
        print('Error updating online status: $e');
      }
    }
  }

  // Logout Functionality
  Future<void> _logout() async {
    if (_driverId != null) {
      try {
        // Mark the driver as offline in Firestore
        await _firestore.collection('drivers').doc(_driverId).update({
          'isOnline': false,
        });
        print('Driver is offline.');
      } catch (e) {
        print('Error updating offline status: $e');
      }
    }

    // Navigate back to the login screen or exit
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markDriverOnline();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plateNumberController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: _logout, // Automatically set to offline on back press
        ),
        title: Text(
          'RideTrack',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : AssetImage('assets/download (1).png')
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _plateNumberController,
                decoration: InputDecoration(
                  labelText: 'Plate Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _contactNumberController,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save and Go Online',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _logout,
                child: const Text(
                  "Logout",
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
