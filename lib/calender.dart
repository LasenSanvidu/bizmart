import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = [];
  Map<DateTime, List<Map<String, dynamic>>> eventsByDay = {};
  bool isLoading = true;
  bool _mounted = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _tabController = TabController(length: 2, vsync: this);
    fetchEvents();
  }

  @override
  void dispose() {
    _mounted = false;
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchEvents() async {
    if (!_mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('events').get();

      if (!_mounted) return;

      List<Map<String, dynamic>> fetchedEvents = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'date': data['date'] ?? '',
          'duration': data['duration'] ?? 1,
        };
      }).toList();

      // Group events by day for the calendar
      Map<DateTime, List<Map<String, dynamic>>> groupedEvents = {};
      for (var event in fetchedEvents) {
        DateTime date = parseDateString(event['date']);
        if (groupedEvents[date] == null) {
          groupedEvents[date] = [];
        }
        groupedEvents[date]!.add(event);
      }

      setState(() {
        events = fetchedEvents;
        eventsByDay = groupedEvents;
        isLoading = false;
      });
    } catch (e) {
      if (!_mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime parseDateString(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      if (parts.length != 3) return DateTime.now();
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  String formatDate(String dateString) {
    try {
      DateTime date = parseDateString(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return eventsByDay[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void showEventDetailsDialog(Map<String, dynamic> event) {
    if (!_mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            event['title'],
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      formatDate(event['date']),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.timelapse, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      "${event['duration']} day(s)",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.black45),
                const SizedBox(height: 16),
                Text(
                  "Description",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event['description'] ?? "No description available",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
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
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, {bool isSmall = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 16,
        vertical: isSmall ? 4 : 8,
      ),
      child: GestureDetector(
        onTap: () => showEventDetailsDialog(event),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: Colors.black26,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmall ? 8 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event['title'],
                        style: GoogleFonts.poppins(
                          fontSize: isSmall ? 14 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (!isSmall) const SizedBox(height: 12),
                if (!isSmall)
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[800]),
                      const SizedBox(width: 4),
                      Text(
                        formatDate(event['date']),
                        style: GoogleFonts.poppins(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                if (!isSmall &&
                    event['description'] != null &&
                    event['description'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      event['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Calendar",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(
              icon: Icon(Icons.calendar_month),
              text: "Calendar",
            ),
            Tab(
              icon: Icon(Icons.format_list_bulleted),
              text: "List",
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No events scheduled",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Calendar View
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            eventLoader: _getEventsForDay,
                            calendarStyle: CalendarStyle(
                              markersMaxCount: 3,
                              markerDecoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              leftChevronIcon: const Icon(
                                Icons.chevron_left,
                                color: Colors.black,
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Colors.black26),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Events on ${DateFormat('MMM d, yyyy').format(_selectedDay!)}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _getEventsForDay(_selectedDay!).isEmpty
                              ? Center(
                                  child: Text(
                                    "No events for this day",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  itemCount:
                                      _getEventsForDay(_selectedDay!).length,
                                  itemBuilder: (context, index) {
                                    final event =
                                        _getEventsForDay(_selectedDay!)[index];
                                    return _buildEventCard(event);
                                  },
                                ),
                        ),
                      ],
                    ),

                    // List View
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildEventCard(event);
                      },
                    ),
                  ],
                ),
    );
  }
}
