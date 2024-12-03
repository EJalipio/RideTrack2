import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pass_profile_reusable.dart';

class PassprofileScreen extends StatefulWidget {
  final String welcomeMessage;

  const PassprofileScreen({super.key, required this.welcomeMessage});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PassprofileScreen> {
  File? _imageFile;
  String? _base64Image;

  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress image to lower quality
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _base64Image = base64Encode(_imageFile!.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
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
              // Display the welcomeMessage in profile screen
              Text(
                widget.welcomeMessage, // Display dynamic welcome message
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 30),

              // Profile Picture Section
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 28),
                      Icon(Icons.star, color: Colors.orange, size: 28),
                      Icon(Icons.star, color: Colors.orange, size: 28),
                      Icon(Icons.star_border, color: Colors.orange, size: 28),
                      Icon(Icons.star_border, color: Colors.orange, size: 28),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '3.5',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : AssetImage('assets/download (2).png')
                                as ImageProvider, // Default image
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: _pickImage,
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Editable Fields
              EditField(
                icon: Icons.person,
                label: 'Name',
                value: '',
              ),
              SizedBox(height: 16),
              EditField(
                icon: Icons.email,
                label: 'Email',
                value: '',
              ),
              SizedBox(height: 16),
              EditField(
                icon: Icons.phone,
                label: 'Contact Number',
                value: '',
              ),
              SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_base64Image != null) {
                    print('Base64 Image: $_base64Image');
                  } else {
                    print('No image selected.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Logout Button
              GestureDetector(
                onTap: () {
                  // Handle logout functionality
                  print("Logout clicked");
                },
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
