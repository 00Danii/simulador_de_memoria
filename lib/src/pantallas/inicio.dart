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
                      'Ingresar la cantidad de páginas necesarias.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Así como el tamaño de dichas páginas\nLos valores disponibles están entre 2^6 y 2^20.',
                      textAlign: TextAlign.center,
                    ),
                    // ... (código anterior)

                    SizedBox(height: 30),
                    const Text(
                      'Se divide la memoria RAM en páginas de tamaño fijo.\n\nSe crea una lista de páginas disponibles que inicialmente contiene toda la memoria.',
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
                      'Ingresar el nombre del proceso y el tamaño del mismo.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(tamanioDePaginas),
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(marcoDePaginacionConProcesos),
                    ),
                    const Text(
                      'Al ingresar procesos; estos se organizan en las páginas de manera que se ocupe siempre el total del tamaño de la página aunque dicho proceso sea de un menor tamaño.\n\nSi el proceso es mayor al tamaño de la página, este se va a dividir ocupando tantas páginas necesite para ser asignado.',
                      textAlign: TextAlign.justify,
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
                      base64Decode(procesosActivosPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'La lista de los procesos activos indica qué procesos se encuentran en estado activo, así como el tamaño de cada uno de los procesos.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lista de Procesos En Espera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cuando el número de páginas está completamente ocupado o se determina que un proceso en específico supera el tamaño de memoria disponible, entonces este proceso se asignará a la lista de procesos en espera.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(procesosEnEsperaPaaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Terminar Procesos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(terminarProcesoPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Para terminar un proceso en estado activo, basta con dar clic sobre el nombre de dicho proceso; esto mostrará un mensaje de confirmación para decidir si realmente se finalizará el proceso o no.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lista de Procesos Terminados",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(listaProcesosTerminados),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'La lista de los procesos terminados indica qué procesos estuvieron en estado activo y se finalizaron, así como el tamaño que cada uno de estos procesos ocupó en la memoria RAM.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Asignación Automática de Procesos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Al finalizar un proceso, se implementa el algoritmo de reemplazo de páginas.\n\nEl algoritmo comienza recorriendo los procesos asignados en las páginas hacia arriba.\n\nPara cada página, se verifica lo siguiente:\n\n\t\t\t● Si la página tiene espacio disponible.\n\t\t\t● Si el tamaño del proceso es menor o igual al tamaño de la página.\n\nSe elige la página que cumple con los requisitos.\n\nEl proceso se asigna a la página seleccionada.\nSe actualiza la lista de páginas disponibles para reflejar el espacio ocupado.\n\nSi quedan procesos en la lista de espera, el algoritmo se repite para asignar el siguiente proceso.\n\nEl algoritmo termina cuando se han asignado todos los procesos posibles, la lista de espera queda vacía o la memoria RAM se llena nuevamente.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(asignacionAutomaticaPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Información de Memoria",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'En esta sección, se proporciona una visión detallada del estado actual de la gestión de memoria en el simulador. Se presentan datos clave que permiten entender cómo se están utilizando los recursos de memoria en el sistema.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Memoria RAM",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Se calcula multiplicando el número total de páginas por el tamaño de cada página. Representa la cantidad total de memoria RAM disponible en el sistema.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Memoria Disponible",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Es el resultado de multiplicar el número de páginas libres por el tamaño de cada página. Indica la cantidad de memoria que aún no ha sido asignada a ningún proceso, lista y preparada para su uso.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Memoria Ocupada",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Se obtiene multiplicando el número de páginas ocupadas por el tamaño de cada página. Representa la cantidad de memoria que actualmente está siendo utilizada por procesos activos en el sistema.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),
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
                      'Ingresar el número de segmentos para la Memoria RAM y para la Memoria Virtual, así como el tamaño de cada uno de los segmentos.\nLos valores disponibles son entre 2^6 y 2^20.',
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
                      'Al ingresar un proceso nuevo, con su nombre y tamaño respectivo, este se va a asignar a uno o más segmentos según el tamaño del proceso y del espacio disponible por segmento.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(procesoNuevoPaginacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ingresar el nombre del proceso y el tamaño del mismo.',
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
                      'Este apartado del simulador muestra una lista de los procesos que se encuentran en estado activo, así como la ubicación de los segmentos que están ocupando y su tamaño de cada uno de los procesos.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Uso de Memoria Virtual",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cuando la RAM está completamente ocupada, se recurre a la memoria virtual. Esta técnica utiliza una combinación de la memoria física (RAM) y el espacio en disco para simular una mayor cantidad de RAM de la que realmente está disponible. Los procesos nuevos se asignan en la memoria virtual.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(memoriaVirtualSegmentacion),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Lista de Procesos En Espera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cuando el número de páginas está completamente ocupado o se determina que un proceso en específico supera el tamaño de memoria disponible, entonces este proceso se asignará a la lista de procesos en espera.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Image.memory(
                      base64Decode(esperaSegmentacion),
                    ),
                    const SizedBox(height: 20),



                    //
                    const SizedBox(height: 20),
                    const Text(
                      "Asignación Automática de Procesos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Esto mediante un algoritmo que se encarga de gestionar la asignación y liberación de segmentos de memoria. Funciona de la siguiente manera:',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cuando un proceso termina su ejecución, el algoritmo revisa los segmentos en búsqueda de espacio liberado.\n\nLos procesos que se encuentran en los segmentos se recorren hacia arriba, y se actualiza la información de cada segmento para reflejar la liberación del espacio.\n\nTras la finalización de un proceso, se actualiza la información de los segmentos restantes.\n\nUna vez actualizada la información de los segmentos, aquellos que no albergan procesos se vacían. Esto asegura que los segmentos estén disponibles para asignación de procesos nuevos.\n\nA continuación, el algoritmo selecciona el proceso de menor tamaño de la lista de espera. Este proceso será el candidato para ser asignado a los segmentos de memoria disponibles.\n\nSe evalúa si el proceso seleccionado puede ser asignado a los segmentos de memoria actuales. Si hay suficiente espacio, el proceso se asigna a los segmentos correspondientes.\n\nEste método de asignación se repite recursivamente para cada proceso en la lista de espera, seleccionando siempre el proceso de menor tamaño. Este ciclo continúa hasta que no se pueda asignar otro proceso debido a la falta de espacio o hasta que la lista de espera quede vacía.',
                      textAlign: TextAlign.justify,
                    ),
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
