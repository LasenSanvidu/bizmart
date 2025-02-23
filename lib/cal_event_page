import 'package:flutter/material.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  DateTime? selectedDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _saveEvent() {
    if (titleController.text.isEmpty || selectedDate == null) return;
    final newEvent = {
      'title': titleController.text,
      'date': "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
      'duration': int.tryParse(durationController.text) ?? 1,
    };
    Navigator.pop(context, newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Event")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Event Title"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Duration (Days)"),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? "Select Date"
                      : " ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvent,
              child: const Text("Save Event"),
            ),
          ],
        ),
      ),
    );
  }
}
