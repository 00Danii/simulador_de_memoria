import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Paginacion extends StatefulWidget {
  const Paginacion({super.key});

  @override
  State<Paginacion> createState() => _PaginacionState();
}

class _PaginacionState extends State<Paginacion> {
  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: tema ? const Color.fromARGB(255, 0, 0, 0) : null,
      body: Center(
        child: Text(
          "PAGINACION",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
