import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simulador_de_memoria/src/imagenes/imagenes.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // hacer metodos para cada columna :v
            SizedBox(
              width: 40.w,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Paginación",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'La paginación es una técnica de gestión de memoria utilizada en sistemas operativos para administrar el espacio de memoria disponible de manera eficiente.\nSe basa en dividir la memoria física en bloques de tamaño fijo llamados "páginas", y organizar el espacio de direcciones de los programas en bloques del mismo tamaño llamados "marcos de página".',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Configuración Inicial",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30),
                    Image.memory(
                      base64Decode(numeroDePaginasPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingresar la cantidad de paginas necesarias.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Así como el tamaño de dichas paginas\nLos valores diponibles son entre 2^6 y 2^20.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Esto va a generar el Marco de Paginación que contiene las paginas.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(marcoDePaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Procesos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Un "proceso" se refiere a un programa en ejecución. Puede ser una aplicación que un usuario está utilizando, como un navegador web o un procesador de texto, o puede ser un componente del sistema operativo mismo.\nEn este simulador solo se representará mediante un nombre y el tamaño del proceso.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(procesoNuevoPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingresar el nombre del proceso, y el tamaño del mismo.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 40.w,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Segmentación",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'La segmentación de memoria es una técnica de gestión de memoria utilizada por los sistemas operativos para organizar y controlar el acceso a la memoria de un sistema de computadora.\nEn un sistema que utiliza segmentación de memoria, el espacio de direcciones de memoria se divide en segmentos o bloques de diferentes tamaños, cada uno con un propósito específico. Cada segmento puede representar una sección lógica de un programa o un conjunto de datos.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Memoria RAM (Random Access Memory)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'La memoria RAM es un tipo de memoria volátil y de acceso rápido utilizada para almacenar temporalmente datos y programas activamente utilizados por una computadora.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Memoria Virtual",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'La memoria virtual es una técnica que utiliza una combinación de la memoria física (RAM) y el espacio en disco para simular una cantidad mayor de RAM de la que realmente existe en un sistema. Se utiliza para gestionar eficientemente la disponibilidad de memoria física en un sistema operativo.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Configuración Inicial",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30),
                    Image.memory(
                      base64Decode(numeroSegmentos),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingresar el número de segmentos para la Memoria RAM y para la Memoria Virtual, así como el tamaño de cada uno de los segmentos.\nLos valores diponibles son entre 2^6 y 2^20.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Esto va a generar los segmentos tanto de la Memoria RAM como de la Memoria Virtual, con su tamaño correspondiente.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(segmentosRamVirtual),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Asignación de Procesos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Al ingresar un proceso nuevo, con su nombre y tamaño respectivo, este se va a asignar a uno o mas segmentos según el tamaño del proceso y del espacio disponible por segmento.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(procesoNuevoPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingresar el nombre del proceso, y el tamaño del mismo.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ejemplo de 2 procesos con 64 y 128 de tamaño correspondiente.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(procesoSegmentacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lista de Procesos Activos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(activosSegmentacion1),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Este apartado del simulador muestra una lista de los procesos que se encuentran en estado activo, así como la hubicación de los segmentos que estan ocupando y su tamaño de cada uno de los procesos.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
