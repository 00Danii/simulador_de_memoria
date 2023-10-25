// ignore: file_names
// import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:simulador_de_memoria/src/imagenes/imagenes.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: tema ? temaObscuro : temaClaro,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: tema ? gris : grisClaro,
        textStyle: TextStyle(
          color: tema ? blanco : negro,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Color(0xff4900ff)),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: tema ? negro : blanco,
          ),
          // gradient: LinearGradient(
          //   colors: [morado],
          // ),
          color: tema ? gris : negro,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: tema ? blanco : negro,
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: tema ? negro : blanco,
          size: 22,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: tema ? temaObscuro : temaClaro,
        ),
      ),
      footerDivider: tema ? dividerClaro : dividerObscuro,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            // child: Image.asset("assets/iconos/memoria.png")),
            child: Image.memory(
              base64Decode(memoria64),
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          iconWidget:
              // Image(image: AssetImage("assets/iconos/home.png"), width: 35),
              Image.memory(
            base64Decode(home64),
            width: 35,
          ),
          label: 'Inicio',
        ),
        SidebarXItem(
          iconWidget: Image.memory(
            base64Decode(paginacion64),
            width: 35,
          ),
          label: 'Paginación',
        ),
        SidebarXItem(
          // iconWidget: Image(
          //     image: AssetImage("assets/iconos/segmentacion.png"), width: 35),
          iconWidget: Image.memory(base64Decode(segmentacion64), width: 35,),
          label: 'Segmentación',
        ),
        // SidebarXItem(
        //   iconWidget:
        //       Image(image: AssetImage("assets/iconos/home.png"), width: 35),
        //   label: 'Ajustes',
        // ),
      ],
    );
  }
}

const canvasColor = Color(0xffba92b8);
const accentCanvasColor = Color.fromARGB(255, 155, 146, 186);
const blanco = Color.fromARGB(255, 255, 255, 255);
const negro = Colors.black;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final dividerClaro = Divider(color: blanco.withOpacity(0.3), height: 1);
final dividerObscuro = Divider(color: negro.withOpacity(0.7), height: 1);
final verde = const Color(0xFF5B7D61).withOpacity(0.5);
const morado = Color(0xFF8C6A8E);
const temaClaro = blanco;
const temaObscuro = negro;
const gris = Color(0xFF171717);
const grisClaro = Color.fromARGB(255, 148, 148, 148);
