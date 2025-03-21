import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    _loadEvents();
  }

  void _loadEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    final List<Map<String, dynamic>> loadedEvents = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'title': doc['title'],
        'date': doc['date'],
        'duration': doc['duration'],
        'description': doc['description'],
        'creatorId': doc['creatorId'], // Ensure creatorId is retrieved
      };
    }).toList();

    if (mounted) {
      setState(() {
        events = loadedEvents;
      });
    }
  }

  void addEvent(Map<String, dynamic> event) {
    if (!mounted) return;
    setState(() {
      events.add(event);
    });
  }

  void _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();

      if (mounted) {
        setState(() {
          events.removeWhere((event) => event['id'] == eventId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete event: $e'),
          backgroundColor: const Color.fromRGBO(251, 250, 250, 1),
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, String eventId, String creatorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Delete Event?",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete this event?",
          style: GoogleFonts.poppins(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[300]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(eventId);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253), // Black Theme Background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 254, 254),
        elevation: 0,
        title: Text(
          "Calendar",
          style: GoogleFonts.poppins(
            color: const Color.fromRGBO(11, 10, 10, 1),
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: events.isEmpty
            ? Center(
                child: Text(
                  "No Events Yet",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[300],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  var event = events[index];
                  String eventId = event['id'];
                  String eventTitle = event['title'];
                  String creatorId = event['creatorId'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 6,
                    shadowColor: const Color.fromARGB(255, 244, 224, 248).withOpacity(0.2),
                    color: const Color(0xFF1E1E1E), // Dark card color
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      title: Text(
                        eventTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "${event['date']}  |  Duration: ${event['duration']} day(s)",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[300],
                        ),
                      ),
                      leading: const Icon(
                        Icons.event,
                        color: Color.fromARGB(255, 250, 231, 250),
                      ),
                      trailing: creatorId == FirebaseAuth.instance.currentUser?.uid
                          ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, eventId, creatorId),
                            )
                          : null, // Hide delete button if not the creator
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: Text(
                                event['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date: ${event['date']}",
                                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Duration: ${event['duration']} day(s)",
                                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Description:",
                                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      event['description'] ?? "No description available",
                                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[300]),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Close",
                                    style: GoogleFonts.poppins(color: Colors.grey[300]),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final event = await context.push("/cal_eve");
          if (event != null) {
            addEvent(event as Map<String, dynamic>);
            _loadEvents();
          }
        },
        backgroundColor: const Color.fromARGB(255, 17, 17, 18),
        label: Text(
          "Add Event",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 255, 254, 254),
          ),
        ),
        icon: const Icon(Icons.add, color: Color.fromARGB(255, 255, 254, 254)),
      ),
    );
  }
}
