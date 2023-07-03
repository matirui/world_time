import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Counter extends StatefulWidget {
  final DateTime now;
  final double size;
  final Color color;
  const Counter(
      {super.key, required this.now, required this.size, required this.color});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late DateTime now;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    now = widget.now;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          now = now.add(const Duration(seconds: 1));
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.jms().format(now),
      style: TextStyle(
        fontSize: widget.size,
        color: widget.color,
      ),
    );
  }
}
