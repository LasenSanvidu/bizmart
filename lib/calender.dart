import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/services/Firebase%20Notification%20Service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenForEventUpdates();
  }

  void listenForEventUpdates() {
    _firestore.collection('events').snapshots().listen((querySnapshot) {
      if (!mounted) return;

      setState(() {
        events = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'title': data['title'] ?? '',
            'description': data['description'] ?? '',
            'date': data['date'] ?? '',
            'duration': data['duration'] ?? 1,
          };
        }).toList();
        isLoading = false;
      });

      // Check for new or updated events and send notifications
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // New event added
          sendNewEventNotification(change.doc);
        } else if (change.type == DocumentChangeType.modified) {
          // Event updated
          sendEventUpdateNotification(change.doc);
        }
      }
    });
  }

  Future<void> sendNewEventNotification(DocumentSnapshot eventDoc) async {
    final Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;
    final String title = data['title'] ?? 'New Event!';
    final String date = formatDate(data['date'] ?? '');
    final String body = 'New event "$title" on $date';

    // Use local notifications for immediate feedback
    NotificationService().showLocalNotification(
      title: 'New Event Added',
      body: body,
    );

    // Store notification in Firestore for client-side pickup
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'New Event Added',
      'body': body,
      'eventId': eventDoc.id,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'new_event',
    });
  }

  Future<void> sendEventUpdateNotification(DocumentSnapshot eventDoc) async {
    final Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;
    final String title = data['title'] ?? 'Event Updated!';
    final String date = formatDate(data['date'] ?? '');
    final String body = 'Event "$title" on $date has been updated';

    // Use local notifications for immediate feedback
    NotificationService().showLocalNotification(
      title: 'Event Updated',
      body: body,
    );

    // Store notification in Firestore for client-side pickup
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'Event Updated',
      'body': body,
      'eventId': eventDoc.id,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'event_update',
    });
  }

  String formatDate(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      if (parts.length != 3) return dateString;
      DateTime date = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar", style: GoogleFonts.poppins(fontSize: 26.0)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? Center(child: Text("No events yet", style: GoogleFonts.poppins(fontSize: 18)))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event['title'], style: GoogleFonts.poppins(fontSize: 18)),
                      subtitle: Text(formatDate(event['date']), style: GoogleFonts.poppins(fontSize: 14)),
                      onTap: () {
                        // Navigate to event details page
                        // You can implement this based on your app's navigation
                      },
                    );
                  },
                ),
    );
  }
}

