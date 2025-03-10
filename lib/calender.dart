import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:myapp/cal_event_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events when the page opens
  }

  void _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEvents = prefs.getString('events');
    if (storedEvents != null) {
      setState(() {
        events = List<Map<String, dynamic>>.from(json.decode(storedEvents));
      });
    }
  }

  void _saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('events', json.encode(events));
  }

  void addEvent(Map<String, dynamic> event) {
    setState(() {
      events.add(event);
      _saveEvents(); // Save the updated list
    });
  }

  void _showQrCode(String qrData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Event QR Code"),
        content: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.push("/");
          },
        ),
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 29.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final event = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventFormPage()),
                );
                if (event != null) {
                  addEvent(event);
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 248, 246, 255),
        child: events.isEmpty
            ? const Center(
                child: Text(
                  "Add your event here",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    color: const Color.fromARGB(255, 245, 221, 249),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: event['qrData'] != null
                          ? IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () => _showQrCode(event['qrData']),
                            )
                          : const Icon(Icons.event),
                      title: Text("${event['title']}"),
                      subtitle: Text(
                          " ${event['date']}  |  Duration: ${event['duration']} day(s)"),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
