import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedTodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Today'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(booking['profileImage'] ??
                        'assets/default_profile.png'),
                  ),
                  title: Text(booking['driverName'] ?? 'Unknown Driver'),
                  subtitle: Text(
                    'Pick-up: ${booking['pickUp']}\nDrop-off: ${booking['dropOff']}',
                  ),
                  trailing: Text(booking['plateNumber'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
