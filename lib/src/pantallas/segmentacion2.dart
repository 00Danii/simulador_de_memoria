// ignore_for_file: use_key_in_widget_constructors, slash_for_doc_comments

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/*****************
 * CLASES MODELO *
 *****************/
class Proceso {
  final int id;
  final String nombre;
  final int tamanio;
  final Color colorClaro;
  final Color colorObscuro;
  Proceso(
      {required this.id,
      required this.nombre,
      required this.tamanio,
      required this.colorClaro,
      required this.colorObscuro});
}

class Segmento {
  String? proceso;
  int procesoId = 0;
  int tamanio;
  Color colorClaro;
  Color colorObscuro;
  List<Proceso> procesos;
  Segmento(
      {required this.tamanio,
      required this.colorObscuro,
      required this.colorClaro,
      required this.procesos});
}

/*************************
 * CLASE DE SEGMENTACION *
 *************************/
class Segmen extends StatefulWidget {
  const Segmen({Key? key});

  @override
  State<Segmen> createState() => _SegmentacionState();
}

class _SegmentacionState extends State<Segmen> {
  TextEditingController numeroDeSegmentosRamControlador =
      TextEditingController();
  TextEditingController numeroDeSegmentosVirtualControlador =
      TextEditingController();
  TextEditingController nombreProcesoController = TextEditingController();

  String tamanioSegmentosRam = '2⁶ => 64';
  String tamanioSegmentosVirtual = '2⁶ => 64';
  String tamanioProceso = '2⁶ => 64';

  final _formKeyRamVirtual = GlobalKey<FormState>();
  final _formKeyProceso = GlobalKey<FormState>();

  List<Segmento> segmentosRam = [];
  List<Segmento> segmentosVirtual = [];
  List<Proceso> procesosActivos = [];
  List<Proceso> procesosEnEspera = [];
  List<Proceso> procesosTerminados = [];
  List<Proceso> procesosCancelados = [];

  int memoriaTotal = 0;
  int memoriaDisponible = 0;
  int memoriaOcupada = 0;
  int memoriaVirtual = 0;
  int siguienteProcesoId = 1;

  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: tema ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            entradasDeRamVirtual(),
            const SizedBox(height: 40),
            entradasDeProcesos(),
            const SizedBox(height: 40),
            if (segmentosRam.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  segmentosRamMetodo(tema),
                  const SizedBox(width: 25),
                  segmentosVirtualMetodo(tema),
                  SizedBox(
                    width: 25.w,
                    child: Column(
                      children: [
                        procesosActivosPantalla(tema),
                        const SizedBox(height: 40),
                        procesosTerminadosPantalla(tema),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25.w,
                    child: Column(
                      children: [
                        procesosEsperaPantalla(tema),
                        const SizedBox(height: 40),
                        procesosCanceladosPantalla(tema),
                        const SizedBox(height: 40),
                        informacionMemoria(),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

/***********************************
 * METODOS DE DIBUJADO DE PANTALLA *
 ***********************************/

  Color generarColorAleatorioClaro() {
    Random random = Random();
    int red = random.nextInt(128) + 128; // Valor entre 128 y 255
    int green = random.nextInt(128) + 128; // Valor entre 128 y 255
    int blue = random.nextInt(128) + 128; // Valor entre 128 y 255

    return Color.fromARGB(255, red, green, blue);
  }

  Color generarColorAleatorioObscuro() {
    Random random = Random();
    int r = random.nextInt(128); // Rojo oscuro
    int g = random.nextInt(128); // Verde oscuro
    int b = random.nextInt(128); // Azul oscuro

    return Color.fromARGB(255, r, g, b);
  }

  SizedBox informacionMemoria() {
    return SizedBox(
      child: Align(
        child: Column(
          children: <Widget>[
            Text(
              'Memoria Total: $memoriaTotal',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Memoria Disponible: $memoriaDisponible',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Memoria Ocupada: $memoriaOcupada',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column procesosCanceladosPantalla(bool tema) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Procesos Cancelados: ${procesosCancelados.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 19),
        Align(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: !tema
                      ? const Color.fromARGB(255, 255, 0, 0)
                      : const Color.fromARGB(255, 255, 0, 0)),
            ),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Tamaño')),
              ],
              rows: procesosCancelados.map<DataRow>(
                (Proceso proceso) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Center(
                            child: Text(
                          proceso.id.toString(),
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          proceso.nombre,
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        )),
                      ),
                      DataCell(
                        Center(
                            child: Text(
                          proceso.tamanio.toString(),
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        )),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Column procesosEsperaPantalla(bool tema) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Procesos en Espera: ${procesosEnEspera.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 19),
        Align(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: !tema
                      ? const Color.fromARGB(255, 217, 255, 0)
                      : const Color.fromARGB(255, 255, 238, 0)),
            ),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Tamaño')),
              ],
              rows: procesosEnEspera.map<DataRow>((Proceso proceso) {
                return DataRow(cells: <DataCell>[
                  DataCell(
                    InkWell(
                      onTap: () {
                        mostrarDialogoConfirmacionCancelar(proceso.id);
                      },
                      child: Center(
                        child: Text(
                          proceso.id.toString(),
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () {
                        mostrarDialogoConfirmacionCancelar(proceso.id);
                      },
                      child: Center(
                        child: Text(
                          proceso.nombre,
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () {
                        mostrarDialogoConfirmacionCancelar(proceso.id);
                      },
                      child: Center(
                        child: Text(
                          proceso.tamanio.toString(),
                          style: TextStyle(
                              color: tema
                                  ? proceso.colorClaro
                                  : proceso.colorObscuro),
                        ),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Column procesosTerminadosPantalla(bool tema) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Procesos Terminados: ${procesosTerminados.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 19),
        Align(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: !tema
                      ? const Color.fromARGB(255, 255, 0, 0)
                      : const Color.fromARGB(255, 255, 0, 0)),
            ),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Tamaño')),
              ],
              rows: procesosTerminados.map<DataRow>(
                (Proceso proceso) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Center(
                          child: Text(
                            proceso.id.toString(),
                            style: TextStyle(
                                color: tema
                                    ? proceso.colorClaro
                                    : proceso.colorObscuro),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            proceso.nombre,
                            style: TextStyle(
                                color: tema
                                    ? proceso.colorClaro
                                    : proceso.colorObscuro),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            proceso.tamanio.toString(),
                            style: TextStyle(
                                color: tema
                                    ? proceso.colorClaro
                                    : proceso.colorObscuro),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Column procesosActivosPantalla(bool tema) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Procesos Activos: ${procesosActivos.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 19),
        Align(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: !tema
                      ? const Color.fromARGB(255, 6, 167, 0)
                      : const Color.fromARGB(255, 107, 255, 66)),
            ),
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Tamaño')),
              ],
              rows: procesosActivos.map<DataRow>(
                (Proceso proceso) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(
                        InkWell(
                          onTap: () => mostrarDialogoConfirmacion(proceso.id),
                          child: Center(
                            child: Text(
                              proceso.id.toString(),
                              style: TextStyle(
                                  color: tema
                                      ? proceso.colorClaro
                                      : proceso.colorObscuro),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () => mostrarDialogoConfirmacion(proceso.id),
                          child: Center(
                            child: Text(
                              proceso.nombre,
                              style: TextStyle(
                                  color: tema
                                      ? proceso.colorClaro
                                      : proceso.colorObscuro),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () => mostrarDialogoConfirmacion(proceso.id),
                          child: Center(
                            child: Text(
                              proceso.tamanio.toString(),
                              style: TextStyle(
                                  color: tema
                                      ? proceso.colorClaro
                                      : proceso.colorObscuro),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox segmentosRamMetodo(bool tema) {
    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Memoria Ram: ${segmentosRam.where((segmento) => segmento.proceso != null).length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segmentosRam.map(
            (segmento) {
              return InkWell(
                onTap: () {
                  if (segmento.proceso != null) {
                    mostrarDialogoConfirmacion(segmento.procesoId);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            tema ? segmento.colorClaro : segmento.colorObscuro),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      segmento.proceso ?? '',
                      style: TextStyle(
                          color: tema
                              ? segmento.colorClaro
                              : segmento.colorObscuro),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  SizedBox segmentosVirtualMetodo(bool tema) {
    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Memoria Virtual: ${segmentosVirtual.where((segmento) => segmento.proceso != null).length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segmentosVirtual.map(
            (segmento) {
              return InkWell(
                onTap: () {
                  if (segmento.proceso != null) {
                    mostrarDialogoConfirmacion(segmento.procesoId);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            tema ? segmento.colorClaro : segmento.colorObscuro),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      segmento.proceso ?? '',
                      style: TextStyle(
                          color: tema
                              ? segmento.colorClaro
                              : segmento.colorObscuro),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  Form entradasDeProcesos() {
    return Form(
      key: _formKeyProceso,
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Proceso Nuevo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: nombreProcesoController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Ingrese el nombre del proceso',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el nombre del proceso';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tamanioProceso,
                  onChanged: (String? valorNuevo) {
                    setState(() {
                      tamanioProceso = valorNuevo!;
                    });
                  },
                  items: <String>[
                    '2⁶ => 64',
                    '2⁷ => 128',
                    '2⁸ => 256',
                    '2⁹ => 512',
                    '2¹⁰ => 1024',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tamaño del proceso',
                  ),
                ),
              ),
              const SizedBox(width: 50),
              ElevatedButton(
                onPressed: () {
                  validarNuevoProceso();
                },
                child: const Text('Aceptar'),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }

  Form entradasDeRamVirtual() {
    return Form(
      key: _formKeyRamVirtual,
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Memoria RAM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: numeroDeSegmentosRamControlador,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Segmentos de la RAM',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '0') {
                      return 'Ingresa los segmentos de la memoria RAM';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tamanioSegmentosRam,
                  onChanged: (String? valorNuevo) {
                    setState(() {
                      tamanioSegmentosRam = valorNuevo!;
                    });
                  },
                  items: <String>[
                    '2⁶ => 64',
                    '2⁷ => 128',
                    '2⁸ => 256',
                    '2⁹ => 512',
                    '2¹⁰ => 1024',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tamaño de cada segmento',
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: TextFormField(
                  controller: numeroDeSegmentosVirtualControlador,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Segmentos de la memoria Virtual',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '0') {
                      return 'Ingresa los segmentos de la memoria virtual';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tamanioSegmentosVirtual,
                  onChanged: (String? valorNuevo) {
                    setState(() {
                      tamanioSegmentosVirtual = valorNuevo!;
                    });
                  },
                  items: <String>[
                    '2⁶ => 64',
                    '2⁷ => 128',
                    '2⁸ => 256',
                    '2⁹ => 512',
                    '2¹⁰ => 1024',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tamaño de cada segmento',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: validarRamYVirtual,
                child: const Text('Aceptar'),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }

/*********************
 * METODOS DE LOGICA *
 *********************/

  void actualizarMemoria() {
    memoriaTotal = segmentosRam.length * segmentosRam[0].tamanio;
    int marcosOcupados =
        segmentosRam.where((marco) => marco.proceso != null).length;
    memoriaOcupada = marcosOcupados * segmentosRam[0].tamanio;
    memoriaDisponible = memoriaTotal - memoriaOcupada;
  }

  void validarRamYVirtual() {
    if (_formKeyRamVirtual.currentState?.validate() ?? false) {
      setState(
        () {
          final cantidadRam = int.parse(numeroDeSegmentosRamControlador.text);
          final tamanioSegmentoRam =
              int.parse(tamanioSegmentosRam.split(' => ')[1]);
          final cantidadVirtual =
              int.parse(numeroDeSegmentosVirtualControlador.text);
          final tamanioSegmentoVirtual =
              int.parse(tamanioSegmentosVirtual.split(' => ')[1]);
          List<Proceso> procesos = [];
          segmentosRam = List.generate(
              cantidadRam,
              (index) => Segmento(
                  tamanio: tamanioSegmentoRam,
                  colorClaro: Colors.white,
                  colorObscuro: Colors.black,
                  procesos: procesos));

          segmentosVirtual = List.generate(
            cantidadVirtual,
            (index) => Segmento(
              tamanio: tamanioSegmentoVirtual,
              colorClaro: Colors.white,
              colorObscuro: Colors.black,
              procesos: procesos,
            ),
          );
        },
      );
    }
  }

  void limpiarProcesosActivos() {
    setState(() {
      procesosActivos.clear();
    });
  }

  void limpiarProcesosEspera() {
    setState(() {
      procesosEnEspera.clear();
    });
  }

  limpiarProcesosTerminados() {
    setState(() {
      procesosTerminados.clear();
    });
  }

  void limpiarProcesosCancelados() {
    setState(() {
      procesosCancelados.clear();
    });
  }

  Proceso obtenerProcesoMenorTamanio(List<Proceso> procesosEnEspera) {
    Proceso procesoMenorTamanio = procesosEnEspera[0];
    for (int i = 1; i < procesosEnEspera.length; i++) {
      if (procesosEnEspera[i].tamanio < procesoMenorTamanio.tamanio) {
        procesoMenorTamanio = procesosEnEspera[i];
      }
    }
    return procesoMenorTamanio;
  }

  void ejecutarProcesoEnEspera() {
    if (procesosEnEspera.isNotEmpty) {
      Proceso proceso = obtenerProcesoMenorTamanio(procesosEnEspera);
      bool asignado = false;
      for (var i = 0; i < segmentosRam.length; i++) {
        var marco = segmentosRam[i];
        if (marco.proceso == null) {
          if (proceso.tamanio <= marco.tamanio) {
            setState(() {
              marco.proceso = proceso.nombre;
              marco.procesoId = proceso.id;
              marco.colorClaro = proceso.colorClaro;
              marco.colorObscuro = proceso.colorObscuro;
              procesosActivos.add(proceso);
              eliminarProcesoEnEspera(proceso.id);
              ejecutarProcesoEnEspera();
            });
            break;
          } else {
            int marcosNecesarios =
                (proceso.tamanio / segmentosRam[0].tamanio).ceil();

            bool espaciosDisponibles = true;
            for (int j = i; j < i + marcosNecesarios; j++) {
              if (j >= segmentosRam.length || segmentosRam[j].proceso != null) {
                espaciosDisponibles = false;
                break;
              }
            }

            if (espaciosDisponibles) {
              setState(() {
                for (int j = i; j < i + marcosNecesarios; j++) {
                  segmentosRam[j].proceso = proceso.nombre;
                  segmentosRam[j].procesoId = proceso.id;
                  segmentosRam[j].colorClaro = proceso.colorClaro;
                  segmentosRam[j].colorObscuro = proceso.colorObscuro;
                }
                // procesosActivos.add(proceso);
                asignado = true;
              });

              // procesosActivos.add(proceso);
              asignado = true;
              break;
            }
          }
        }
      }

      if (asignado) {
        // Agregar el proceso a la lista de Activos
        setState(() {
          procesosActivos.add(proceso);
          eliminarProcesoEnEspera(proceso.id);
          ejecutarProcesoEnEspera();
        });
      }
      actualizarMemoria();
    }
  }

  void validarNuevoProceso() {
    if (_formKeyProceso.currentState?.validate() ?? false) {
      final nombreProceso = nombreProcesoController.text;
      final tamanioProcesoValue = int.parse(tamanioProceso.split(' => ')[1]);

      bool asignado = false;

      for (var i = 0; i < segmentosRam.length; i++) {
        var marco = segmentosRam[i];
        if (marco.proceso == null) {
          if (tamanioProcesoValue <= marco.tamanio) {
            setState(() {
              // Asignar proceso completo a un marco
              marco.proceso = nombreProceso;
              asignado = true;
            });
            int procesoId = siguienteProcesoId++;
            Color colorClaro = generarColorAleatorioClaro();
            Color colorObscuro = generarColorAleatorioObscuro();
            procesosActivos.add(Proceso(
                id: procesoId,
                nombre: nombreProceso,
                tamanio: tamanioProcesoValue,
                colorClaro: colorClaro,
                colorObscuro: colorObscuro));
            marco.procesoId = procesoId;
            setState(() {
              marco.colorClaro = colorClaro;
              marco.colorObscuro = colorObscuro;
            });
            break;
          } else {
            // Este marco no tiene suficiente espacio para el proceso completo
            // Se debe buscar otro marco o fragmentar el proceso
            int marcosNecesarios = (tamanioProcesoValue / marco.tamanio).ceil();

            bool espaciosDisponibles = true;
            for (int j = i; j < i + marcosNecesarios; j++) {
              if (j >= segmentosRam.length || segmentosRam[j].proceso != null) {
                espaciosDisponibles = false;
                break;
              }
            }

            if (espaciosDisponibles) {
              Color colorClaro = generarColorAleatorioClaro();
              Color colorObscuro = generarColorAleatorioObscuro();

              setState(() {
                for (int j = i; j < i + marcosNecesarios; j++) {
                  segmentosRam[j].proceso = nombreProceso;
                  segmentosRam[j].procesoId = siguienteProcesoId;
                  segmentosRam[j].colorClaro = colorClaro;
                  segmentosRam[j].colorObscuro = colorObscuro;
                }
              });

              int procesoId = siguienteProcesoId++;
              procesosActivos.add(Proceso(
                  id: procesoId,
                  nombre: nombreProceso,
                  tamanio: tamanioProcesoValue,
                  colorClaro: colorClaro,
                  colorObscuro: colorObscuro));
              asignado = true;
              break;
            }
          }
        }
      }

      if (!asignado) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Memoria Insuficiente'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('¿Asignar proceso a la lista de espera?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    // Agregar el proceso a la lista de espera
                    setState(() {
                      procesosEnEspera.add(Proceso(
                          id: siguienteProcesoId++,
                          nombre: nombreProceso,
                          tamanio: tamanioProcesoValue,
                          colorClaro: generarColorAleatorioClaro(),
                          colorObscuro: generarColorAleatorioObscuro()));
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      nombreProcesoController.clear();
      actualizarMemoria();
    }
  }

  void eliminarProceso(int procesoId) {
    setState(() {
      int marcosOcupados = 0;
      if (procesosActivos.any((proceso) => proceso.id == procesoId)) {
        for (var marco in segmentosRam) {
          if (marco.proceso != null && marco.procesoId == procesoId) {
            marco.proceso = null;
            marco.procesoId = 0; // Resetea el procesoId
            marcosOcupados++;
          }
        }

        Proceso procesoTerminado =
            procesosActivos.firstWhere((proceso) => proceso.id == procesoId);
        procesosTerminados.add(procesoTerminado);
        procesosActivos.removeWhere((proceso) => proceso.id == procesoId);
        List<Proceso> procesos = [];
        // Liberar marcos y recorrer procesos hacia arriba
        for (int j = 0; j < marcosOcupados; j++) {
          for (int i = 0; i < segmentosRam.length - 1; i++) {
            if (segmentosRam[i].proceso == null) {
              segmentosRam[i] = segmentosRam[i + 1];
              segmentosRam[i + 1] = Segmento(
                  tamanio: int.parse(tamanioSegmentosRam.split(' => ')[1]),
                  colorClaro: Colors.white,
                  colorObscuro: Colors.black,
                  procesos: procesos);
            }
          }
        }

        ejecutarProcesoEnEspera(); // Intentar ejecutar un proceso en espera
      }
      actualizarMemoria();
    });
  }

  void eliminarProcesoEnEspera(int procesoId) {
    setState(
      () {
        procesosEnEspera.removeWhere((proceso) => proceso.id == procesoId);
      },
    );
  }

  void cancelarProcesoEnEspera(int procesoId) {
    setState(() {
      Proceso procesoEnEspera =
          procesosEnEspera.firstWhere((proceso) => proceso.id == procesoId);
      procesosCancelados.add(procesoEnEspera);
      procesosEnEspera.removeWhere((proceso) => proceso.id == procesoId);
    });
  }

  Future<void> mostrarDialogoConfirmacion(int procesoId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terminar Proceso'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres terminar este proceso?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                eliminarProceso(procesoId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> mostrarDialogoConfirmacionCancelar(int procesoId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Proceso'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres cancelar este proceso?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                cancelarProcesoEnEspera(procesoId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmacionAgregarProcesoMayorAMemoria() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Advertencia'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'El tamaño de este proceso supera al de la memoria total, por lo que nunca se ejecutará\n\n¿Estás seguro de que quieres agregar este proceso?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                nombreProcesoController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                validarNuevoProceso();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
