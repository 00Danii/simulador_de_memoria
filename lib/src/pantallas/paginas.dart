import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:simulador_de_memoria/src/pantallas/inicio.dart';
import 'package:simulador_de_memoria/src/pantallas/paginacion.dart';
import 'package:simulador_de_memoria/src/pantallas/segmentacion.dart';

class Paginas extends StatelessWidget {
  const Paginas({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const Paginacion();
          case 1:
            return const Paginacion();
          case 2:
            return const Segmentacion();
          default:
            return const Center();
        }
      },
    );
  }
}
