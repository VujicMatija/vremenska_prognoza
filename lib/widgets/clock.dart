import 'dart:async';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  TimeOfDay time = TimeOfDay.now();
  String period = TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM';
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time.minute != TimeOfDay.now().minute) {
        setState(() {
          time = TimeOfDay.now();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return time.minute < 10
        ? Text(
            '${time.hour}:0${time.minute} $period',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          )
        : Text(
            '${time.hour}:${time.minute} $period',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          );
  }
}
