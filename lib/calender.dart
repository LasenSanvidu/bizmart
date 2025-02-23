import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/cal_event_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Map<String, dynamic>> events = [];

  void addEvent(Map<String, dynamic> event) {
    setState(() {
      events.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
        title: const Text(
          " Calendar",
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
                  MaterialPageRoute(builder: (context) => EventFormPage()),
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
        color: const Color.fromARGB(
            255, 248, 246, 255), // Set the background color to a light purple
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              color: const Color.fromARGB(255, 245, 221, 249),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
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
