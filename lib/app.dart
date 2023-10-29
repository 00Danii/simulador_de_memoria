import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:simulador_de_memoria/src/pantallas/home.dart';
import 'package:simulador_de_memoria/src/tema/tema.dart';

class Simulador extends StatefulWidget {
  const Simulador({super.key});

  @override
  State<Simulador> createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {
  // @override
  // void initState() {
  //   super.initState();
  //   testWindowSize();
  // }

  // testWindowSize() async {
  //   await DesktopWindow.setFullScreen(true);
  //   await DesktopWindow.setMinWindowSize(const Size(1200, 700));
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Memoria',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
