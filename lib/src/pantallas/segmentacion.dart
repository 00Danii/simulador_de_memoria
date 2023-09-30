import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

class Segmentacion extends StatefulWidget {
  const Segmentacion({super.key});

  @override
  State<Segmentacion> createState() => _SegmentacionState();
}

class _SegmentacionState extends State<Segmentacion> {
  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: tema ? const Color.fromARGB(255, 0, 0, 0) : null,
      body: const Center(
        child: Text(
          "SEGMENTACION",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
