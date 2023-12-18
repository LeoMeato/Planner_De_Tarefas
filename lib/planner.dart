import 'package:Planner_De_Tarefas/arguments.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Planner extends StatefulWidget {
  const Planner({super.key});

  static const routeName = "/planner";

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Id;
    int taskBoardId = args.id;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;
    CalendarFormat _calendarFormat = CalendarFormat.month;
    return Scaffold(appBar: AppBar(
      toolbarHeight: 40, 
      backgroundColor: Colors.white, 
      centerTitle: true,
      title:Text(
        "Task", 
        style:TextStyle(color:Colors.black)
        ,)
        ),
        body: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
));
  }
}
