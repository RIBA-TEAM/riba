import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/parent_bottom_nav.dart';

class ParentCalendarScreen extends StatefulWidget {
  const ParentCalendarScreen({super.key});

  @override
  State<ParentCalendarScreen> createState() => _ParentCalendarScreenState();
}

class _ParentCalendarScreenState extends State<ParentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  Stream<List<Map<String, dynamic>>> _getEvents({
    required String parentId,
    required String studentId,
  }) {
    return FirebaseFirestore.instance
        .collection('calender_events')
        .where('student_id', isEqualTo: studentId)
        .where('parent_id', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) {
          final events = snapshot.docs.map((doc) {
            final data = doc.data();
            data['docId'] = doc.id;
            return data;
          }).toList();

          events.sort((a, b) {
            final aDate = _parseDate(a['date']);
            final bDate = _parseDate(b['date']);
            return aDate.compareTo(bDate);
          });

          return events;
        });
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime(2000);
    return DateTime(2000);
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.$year • $hour:$minute';
  }

  static Color _badgeColor(String type) {
    switch (type.toLowerCase()) {
      case 'guidance':
        return const Color(0xFF1193D4);
      case 'meeting':
        return const Color(0xFF10B981);
      case 'school':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Map<String, dynamic>> _eventsForSelectedDay(
    List<Map<String, dynamic>> allEvents,
  ) {
    if (_selectedDay == null) return [];
    final selected = _dateOnly(_selectedDay!);

    return allEvents.where((event) {
      final eventDate = _dateOnly(_parseDate(event['date']));
      return eventDate == selected;
    }).toList();
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupEventsByDay(
    List<Map<String, dynamic>> events,
  ) {
    final Map<DateTime, List<Map<String, dynamic>>> grouped = {};

    for (final event in events) {
      final day = _dateOnly(_parseDate(event['date']));
      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(event);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);
    const bgDark = Color(0xFF101C22);
    const cardDark = Color(0xFF173746);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String parentId = args?['parentId'] ?? '';
    final String parentName = args?['parentName'] ?? 'Parent';
    final String studentId = args?['studentId'] ?? '';
    final String studentName = args?['studentName'] ?? 'Student';
    final String studentClass = args?['studentClass'] ?? '-';
    final String schoolNo = args?['schoolNo'] ?? '-';
   

    final Map<String, dynamic> parentArgs = {
      'parentId': parentId,
      'parentName': parentName,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'schoolNo': schoolNo,
    };

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tealDeep, primary],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.10),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const Text(
                                'Calendar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Schedule for $studentName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Parent: $parentName',
                                style: const TextStyle(
                                  color: Color(0xCCFFFFFF),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Class: $studentClass   •   School No: $schoolNo',
                                style: const TextStyle(
                                  color: Color(0xB3FFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (studentId.isEmpty || parentId.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                'Parent ID or Student ID not found.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          StreamBuilder<List<Map<String, dynamic>>>(
                            stream: _getEvents(
                              parentId: parentId,
                              studentId: studentId,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      'An error occurred: ${snapshot.error}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final events = snapshot.data ?? [];
                              final groupedEvents = _groupEventsByDay(events);
                              final selectedDayEvents = _eventsForSelectedDay(
                                events,
                              );

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                        ),
                                      ),
                                      child:
                                          TableCalendar<Map<String, dynamic>>(
                                            firstDay: DateTime.utc(2020, 1, 1),
                                            lastDay: DateTime.utc(2035, 12, 31),
                                            focusedDay: _focusedDay,
                                            selectedDayPredicate: (day) =>
                                                isSameDay(_selectedDay, day),
                                            eventLoader: (day) =>
                                                groupedEvents[_dateOnly(day)] ??
                                                [],
                                            calendarFormat:
                                                CalendarFormat.month,
                                            startingDayOfWeek:
                                                StartingDayOfWeek.monday,
                                            availableCalendarFormats: const {
                                              CalendarFormat.month: 'Month',
                                            },
                                            headerStyle: const HeaderStyle(
                                              titleCentered: true,
                                              formatButtonVisible: false,
                                              titleTextStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              leftChevronIcon: Icon(
                                                Icons.chevron_left,
                                                color: Colors.white,
                                              ),
                                              rightChevronIcon: Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                              ),
                                            ),
                                            daysOfWeekStyle:
                                                const DaysOfWeekStyle(
                                                  weekdayStyle: TextStyle(
                                                    color: Color(0xCCFFFFFF),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  weekendStyle: TextStyle(
                                                    color: Color(0xCCFFFFFF),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                            calendarStyle: CalendarStyle(
                                              defaultTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              weekendTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              outsideTextStyle: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.35,
                                                ),
                                              ),
                                              todayDecoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.16,
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white70,
                                                  width: 1.2,
                                                ),
                                              ),
                                              selectedDecoration:
                                                  const BoxDecoration(
                                                    color: primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                              markerDecoration:
                                                  const BoxDecoration(
                                                    color: Color(0xFF10E0A5),
                                                    shape: BoxShape.circle,
                                                  ),
                                              markersMaxCount: 3,
                                              markerMargin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1.2,
                                                  ),
                                            ),
                                            onDaySelected:
                                                (selectedDay, focusedDay) {
                                                  setState(() {
                                                    _selectedDay = selectedDay;
                                                    _focusedDay = focusedDay;
                                                  });
                                                },
                                            onPageChanged: (focusedDay) {
                                              _focusedDay = focusedDay;
                                            },
                                          ),
                                    ),

                                    const SizedBox(height: 18),

                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 46,
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Icon(
                                              Icons.event_available,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _selectedDay == null
                                                      ? 'Selected Day'
                                                      : 'Events on ${_selectedDay!.day}.${_selectedDay!.month}.${_selectedDay!.year}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  selectedDayEvents.isEmpty
                                                      ? 'No events on this date.'
                                                      : '${selectedDayEvents.length} event(s) found.',
                                                  style: const TextStyle(
                                                    color: Color(0xCCFFFFFF),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    if (events.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: const Text(
                                          'No calendar events found for this parent/student.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    else if (selectedDayEvents.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        child: const Text(
                                          'There are no events on the selected day.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    else
                                      Column(
                                        children: selectedDayEvents.map((
                                          event,
                                        ) {
                                          final title =
                                              (event['title'] ?? 'Event')
                                                  .toString();
                                          final description =
                                              (event['description'] ?? '')
                                                  .toString();
                                          final location =
                                              (event['location'] ?? '-')
                                                  .toString();
                                          final type =
                                              (event['event_type'] ?? 'general')
                                                  .toString();
                                          final date = _parseDate(
                                            event['date'],
                                          );
                                          final typeColor = _badgeColor(type);

                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: cardDark.withOpacity(0.92),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.05,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        title,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: typeColor
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        type,
                                                        style: TextStyle(
                                                          color: typeColor,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.schedule,
                                                      color: Color(0xFFB0BEC5),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      _formatDate(date),
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFFB0BEC5,
                                                        ),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Color(0xFFB0BEC5),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      location,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFFB0BEC5,
                                                        ),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (description.isNotEmpty) ...[
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    description,
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      height: 1.35,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ParentBottomNav(selectedIndex: 2, args: parentArgs),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
