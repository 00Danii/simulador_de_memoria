import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: tema ? const Color.fromARGB(255, 0, 0, 0) : null,
      body: Center(
        child: Text(
          "INICIO",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
