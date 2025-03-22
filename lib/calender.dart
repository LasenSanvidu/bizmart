import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> fetchEvents() async {
    if (!_mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('events').get();

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
    } catch (e) {
      if (!_mounted) return;
      setState(() {
        isLoading = false;
      });
    }
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

  void showEventDetailsDialog(Map<String, dynamic> event) {
    if (!_mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            event['title'],
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date: ${formatDate(event['date'])}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blue[300],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: ${event['duration']} day(s)",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.purple[300],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  event['description'] ?? "No description available",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        elevation: 2,
        title: Text(
          "Calendar",
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : events.isEmpty
              ? Center(
                  child: Text(
                    "No events yet",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () => showEventDetailsDialog(event),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(137, 51, 50, 50),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatDate(event['date']),
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue[300],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
