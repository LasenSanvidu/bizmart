import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    _loadEvents(); // Load events when the page is first created
  }

  void _loadEvents() async {
    // Fetch events from Firestore
    final snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    final List<Map<String, dynamic>> loadedEvents = snapshot.docs.map((doc) {
      return {
        'id': doc.id, // Store the document ID for reference
        'title': doc['title'],
        'date': doc['date'],
        'duration': doc['duration'],
        'description': doc['description'], // Ensure description is fetched
      };
    }).toList();

    if (mounted) {
      setState(() {
        events =
            loadedEvents; // Update the state with the events from Firestore
      });
    }
  }

  void addEvent(Map<String, dynamic> event) {
    if (!mounted) return; // Ensure the widget is still active

    setState(() {
      events.add(event); // Add the new event to the list
    });
  }

  void _deleteEvent(String eventId) async {
    try {
      // Delete the event from Firestore
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();

      if (mounted) {
        // Remove the event from the list in the UI
        setState(() {
          events.removeWhere((event) => event['id'] == eventId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Calendar",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6FF), Color(0xFFE5D3FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: events.isEmpty
              ? Center(
                  child: Text(
                    "No Events Yet",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 6,
                      shadowColor: Colors.purpleAccent.withOpacity(0.2),
                      color: const Color(0xFFF5DDF9),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                        title: Text(
                          event['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          "${event['date']}  |  Duration: ${event['duration']} day(s)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        leading: const Icon(
                          Icons.event,
                          color: Colors.deepPurpleAccent,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete Event?"),
                                content: Text(
                                    "Are you sure you want to delete this event?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      _deleteEvent(event['id']);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  event['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date: ${event['date']}",
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Duration: ${event['duration']} day(s)",
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Description:",
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        event['description'] ??
                                            "No description available",
                                        style:
                                            GoogleFonts.poppins(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: Text("Close",
                                        style: GoogleFonts.poppins()),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final event = await context.push("/cal_eve");
          if (event != null) {
            addEvent(event as Map<String, dynamic>);
            _loadEvents();
          }
        },
        backgroundColor: Colors.deepPurpleAccent,
        label: Text(
          "Add Event",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
