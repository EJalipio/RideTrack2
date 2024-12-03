import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'paga2_booking.dart';

class BookPassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers Status'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No drivers found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final driver = doc.data() as Map<String, dynamic>;
              bool isOnline = driver['isOnline'] ?? false;

              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: driver['profileImage'] != null
                      ? NetworkImage(driver['profileImage'])
                      : AssetImage('assets/download (1).png') as ImageProvider,
                ),
                title: Row(
                  children: [
                    Text(
                      driver['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plate Number: ${driver['plateNumber']}'),
                    Text('Contact: ${driver['contactNumber']}'),
                  ],
                ),
                onTap: () {
                  if (isOnline) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Paga2Booking(
                          driverName: driver['name'],
                          plateNumber: driver['plateNumber'],
                          contactNumber: driver['contactNumber'],
                          profileImage: driver['profileImage'] ?? '',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Driver is offline.')),
                    );
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
