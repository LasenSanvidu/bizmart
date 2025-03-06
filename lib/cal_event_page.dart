import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  DateTime? selectedDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  bool addQr = false;
  String? qrData;

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
        _generateQrCode();
      });
    }
  }

  void _generateQrCode() {
    if (addQr && titleController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        qrData = jsonEncode({
          'title': titleController.text,
          'date':
              "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
          'duration':
              durationController.text.isEmpty ? "1" : durationController.text,
        });
      });
    }
  }

  void _saveEvent() {
    if (titleController.text.isEmpty || selectedDate == null) return;

    final newEvent = {
      'title': titleController.text,
      'date':
          "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
      'duration': int.tryParse(durationController.text) ?? 1,
      'qrData': addQr ? qrData : null,
    };

    Navigator.pop(context, newEvent);
  }

  void _showQrCode() {
    if (qrData == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Generated QR Code"),
        content: QrImageView(
          data: qrData!,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        actions: [
          if (qrData != null)
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: _showQrCode,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Event Title"),
              onChanged: (_) => _generateQrCode(),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Duration (Days)"),
              onChanged: (_) => _generateQrCode(),
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
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  value: addQr,
                  onChanged: (bool? value) {
                    setState(() {
                      addQr = value ?? false;
                      _generateQrCode();
                    });
                  },
                ),
                const Text("Add QR Code"),
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
