import 'package:flutter/material.dart';
import 'package:myapp/cal_event_page';

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
        title: Text(
          " Calendar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            backgroundColor: Colors.purple[100],
          ),
        ),
        actions: [
          IconButton(
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
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            color: Colors.purple[100],
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text("${event['title']}"),
              subtitle: Text(
                  "📅 ${event['date']}  |  Duration: ${event['duration']} day(s)"),
            ),
          );
        },
      ),
    );
  }
}
