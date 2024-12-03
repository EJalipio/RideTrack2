import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Paga2Booking extends StatefulWidget {
  final String driverName;
  final String plateNumber;
  final String contactNumber;
  final String profileImage;

  Paga2Booking({
    required this.driverName,
    required this.plateNumber,
    required this.contactNumber,
    required this.profileImage,
  });

  @override
  _Paga2BookingState createState() => _Paga2BookingState();
}

class _Paga2BookingState extends State<Paga2Booking> {
  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();

  Future<void> _submitBooking() async {
    final bookingDetails = {
      'driverName': widget.driverName,
      'plateNumber': widget.plateNumber,
      'contactNumber': widget.contactNumber,
      'profileImage': widget.profileImage,
      'pickUp': _pickUpController.text,
      'dropOff': _dropOffController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .add(bookingDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking submitted successfully')),
      );

      _pickUpController.clear();
      _dropOffController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not submit booking')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.shade50,
                Colors.orange.shade100,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: widget.profileImage.isNotEmpty
                      ? NetworkImage(widget.profileImage)
                      : AssetImage('assets/placeholder.png') as ImageProvider,
                ),
                SizedBox(height: 10),
                Text(
                  'Driver: ${widget.driverName}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 5),
                Text('Plate Number: ${widget.plateNumber}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text('Contact: ${widget.contactNumber}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _pickUpController,
                    decoration: InputDecoration(
                      hintText: 'Pick-up',
                      prefixIcon: Icon(Icons.place, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _dropOffController,
                    decoration: InputDecoration(
                      hintText: 'Drop-off',
                      prefixIcon: Icon(Icons.pin_drop, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Submit Booking',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
