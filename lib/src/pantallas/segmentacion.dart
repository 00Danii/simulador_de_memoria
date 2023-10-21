import 'dart:collection';
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
  final int tamanioTotal;
  final Color colorClaro;
  final Color colorObscuro;
  int espacioAsignado = 0;
  int espacioSinAsignar = 0;
  int espacioAsignadoEnProceso = 0;
  // el primero es el id del segmento
  // el segundo el tamaño asignado al segmento
  HashMap<String, int> espacioOcupadoEnSegmento = HashMap<String, int>();

  Proceso(
      {required this.id,
      required this.nombre,
      required this.tamanioTotal,
      required this.colorClaro,
      required this.colorObscuro,
      required this.espacioSinAsignar});
}

class Segmento {
  int id;
  int tamanio;
  Color colorClaro;
  Color colorObscuro;
  List<Proceso> procesos;
  int espacioOcupado = 0;
  int espacioDisponible;
  Segmento(
      {required this.tamanio,
      required this.colorObscuro,
      required this.colorClaro,
      required this.procesos,
      required this.espacioDisponible,
      required this.id});
}

class Segmentacion extends StatefulWidget {
  const Segmentacion({super.key});

  @override
  State<Segmentacion> createState() => _SegmentacionState();
}

class _SegmentacionState extends State<Segmentacion> {
  TextEditingController numeroDeSegmentosRamControlador =
      TextEditingController();
  TextEditingController numeroDeSegmentosVirtualControlador =
      TextEditingController();
  TextEditingController nombreProcesoController = TextEditingController();

  String tamanioSegmentosRam = '2⁶ => 64';
  String tamanioSegmentosVirtual = '2⁶ => 64';
  String tamanioSegmentosRamyVirtual = '2⁶ => 64';
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
  int segmentoId = 1;

  bool entradaDeSegmentosHabilitado = true;
  bool entradaDeProcesoHablitados = false;

  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: tema ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            entradasRamVirtual(),
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
            reiniciarSegmentacion(),
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
                          proceso.tamanioTotal.toString(),
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
                          proceso.tamanioTotal.toString(),
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
                            proceso.tamanioTotal.toString(),
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
                          onTap: () =>
                              mostrarDialogoConfirmacionTerminarProceso(
                                  proceso),
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
                          onTap: () =>
                              mostrarDialogoConfirmacionTerminarProceso(
                                  proceso),
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
                          onTap: () =>
                              mostrarDialogoConfirmacionTerminarProceso(
                                  proceso),
                          child: Center(
                            child: Text(
                              proceso.tamanioTotal.toString(),
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

  SizedBox segmentosVirtualMetodo(bool tema) {
    List<Widget> buildProcesoList(Segmento segmento) {
      List<Widget> listaProcesos = [];

      for (Proceso proceso in segmento.procesos) {
        listaProcesos.add(
          Text(
            proceso.nombre,
            style: TextStyle(
              color: tema ? proceso.colorClaro : proceso.colorObscuro,
            ),
          ),
        );
      }

      return listaProcesos;
    }

    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Memoria Virtual: ${segmentosVirtual.where((segmento) => segmento.procesos.isNotEmpty).length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: tema ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segmentosVirtual.map(
            (segmento) {
              return InkWell(
                onTap: () {
                  if (segmento.procesos.isNotEmpty) {
                    // mostrarDialogoConfirmacion(segmento.procesoId);
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
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Alineación a la izquierda
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Id: ${segmento.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Total: ${segmento.tamanio}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Ocupado: ${segmento.espacioOcupado}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Disponible: ${segmento.espacioDisponible}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView(
                          shrinkWrap: true,
                          children: buildProcesoList(segmento),
                        ),
                      ],
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

  SizedBox segmentosRamMetodo(bool tema) {
    List<Widget> buildProcesoList(Segmento segmento) {
      List<Widget> listaProcesos = [];

      for (Proceso proceso in segmento.procesos) {
        listaProcesos.add(
          Text(
            proceso.nombre,
            style: TextStyle(
              color: tema ? proceso.colorClaro : proceso.colorObscuro,
            ),
          ),
        );
      }

      return listaProcesos;
    }

    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Memoria Ram: ${segmentosRam.where((segmento) => segmento.procesos.isNotEmpty).length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: tema ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segmentosRam.map(
            (segmento) {
              return InkWell(
                onTap: () {
                  if (segmento.procesos.isNotEmpty) {
                    // mostrarDialogoConfirmacion(segmento.procesoId);
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
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Alineación a la izquierda
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Id: ${segmento.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Total: ${segmento.tamanio}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Ocupado: ${segmento.espacioOcupado}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          'Espacio Disponible: ${segmento.espacioDisponible}',
                          style: TextStyle(
                            fontSize: 12,
                            color: !tema ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView(
                          shrinkWrap: true,
                          children: buildProcesoList(segmento),
                        ),
                      ],
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

  SizedBox segmentosRamMetodos(bool tema) {
    List<Widget> buildProcesoList(Segmento segmento) {
      List<Widget> listaProcesos = [];

      for (Proceso proceso in segmento.procesos) {
        listaProcesos.add(
          Text(
            proceso.nombre,
            style: TextStyle(
              color: tema ? proceso.colorClaro : proceso.colorObscuro,
            ),
          ),
        );
      }

      return listaProcesos;
    }

    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Memoria Ram: ${segmentosRam.where((segmento) => segmento.procesos.isNotEmpty).length}',
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
                  if (segmento.procesos.isNotEmpty) {
                    // mostrarDialogoConfirmacion(segmento.procesoId);
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
                    child: ListView(
                      shrinkWrap: true,
                      children: buildProcesoList(segmento),
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
                  enabled: entradaDeProcesoHablitados,
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
                  onChanged: entradaDeProcesoHablitados
                      ? (String? valorNuevo) {
                          setState(() {
                            tamanioProceso = valorNuevo!;
                          });
                        }
                      : null,
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
                onPressed:
                    entradaDeProcesoHablitados ? validarNuevoProceso : null,
                child: const Text('Aceptar'),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }

  Form entradasRamVirtual() {
    return Form(
      key: _formKeyRamVirtual,
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Memoria RAM y Memoria Virtual',
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
                  enabled: entradaDeSegmentosHabilitado,
                  controller: numeroDeSegmentosRamControlador,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Segmentos de la RAM y Virtual',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '0') {
                      return 'Ingresa los segmentos de la memoria RAM y Virtual';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tamanioSegmentosRamyVirtual,
                  onChanged: entradaDeSegmentosHabilitado
                      ? (String? valorNuevo) {
                          setState(() {
                            tamanioSegmentosRamyVirtual = valorNuevo!;
                          });
                        }
                      : null,
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
              // const SizedBox(width: 50),
              // Expanded(
              //   child: TextFormField(
              //     controller: numeroDeSegmentosVirtualControlador,
              //     keyboardType: TextInputType.number,
              //     inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //     ],
              //     decoration: const InputDecoration(
              //       labelText: 'Segmentos de la memoria Virtual',
              //     ),
              //     validator: (value) {
              //       if (value == null || value.isEmpty || value == '0') {
              //         return 'Ingresa los segmentos de la memoria virtual';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              // const SizedBox(width: 10),
              // Expanded(
              //   child: DropdownButtonFormField<String>(
              //     value: tamanioSegmentosVirtual,
              //     onChanged: (String? valorNuevo) {
              //       setState(() {
              //         tamanioSegmentosVirtual = valorNuevo!;
              //       });
              //     },
              //     items: <String>[
              //       '2⁶ => 64',
              //       '2⁷ => 128',
              //       '2⁸ => 256',
              //       '2⁹ => 512',
              //       '2¹⁰ => 1024',
              //     ].map<DropdownMenuItem<String>>(
              //       (String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       },
              //     ).toList(),
              //     decoration: const InputDecoration(
              //       labelText: 'Tamaño de cada segmento',
              //     ),
              //   ),
              // ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed:
                    entradaDeSegmentosHabilitado ? validarRamYVirtual : null,
                child: const Text('Aceptar'),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }

  void validarRamYVirtual() {
    if (_formKeyRamVirtual.currentState?.validate() ?? false) {
      setState(
        () {
          final cantidadRam = int.parse(numeroDeSegmentosRamControlador.text);
          final tamanioSegmentoRam =
              int.parse(tamanioSegmentosRamyVirtual.split(' => ')[1]);

          final cantidadVirtual = cantidadRam;
          final tamanioSegmentoVirtual = tamanioSegmentoRam;

          segmentosRam = List.generate(
            cantidadRam,
            (index) => Segmento(
                id: segmentoId++,
                tamanio: tamanioSegmentoRam,
                colorClaro: Colors.white,
                colorObscuro: Colors.black,
                procesos: [],
                espacioDisponible:
                    tamanioSegmentoRam // Cada segmento tiene su propia lista de procesos
                ),
          );

          segmentoId = 1;
          segmentosVirtual = List.generate(
            cantidadVirtual,
            (index) => Segmento(
                id: segmentoId++,
                tamanio: tamanioSegmentoVirtual,
                colorClaro: Colors.white,
                colorObscuro: Colors.black,
                procesos: [],
                espacioDisponible:
                    tamanioSegmentoVirtual // Cada segmento tiene su propia lista de procesos
                ),
          );

          actualizarMemoria();
          limpiarProcesosActivos();
          limpiarProcesosEspera();
          limpiarProcesosTerminados();
          limpiarProcesosCancelados();
          siguienteProcesoId = 1;

          entradaDeSegmentosHabilitado = false;
          entradaDeProcesoHablitados = true;
        },
      );
    }
  }

  // void validarNuevoProceso() {
  //   if (_formKeyProceso.currentState?.validate() ?? false) {
  //     final nombreProceso = nombreProcesoController.text;
  //     final tamanioProcesoValue = int.parse(tamanioProceso.split(' => ')[1]);
  //     Color colorClaro = generarColorAleatorioClaro();
  //     Color colorObscuro = generarColorAleatorioObscuro();

  //     Proceso proceso = Proceso(
  //       id: siguienteProcesoId++,
  //       nombre: nombreProceso,
  //       tamanioTotal: tamanioProcesoValue,
  //       colorClaro: colorClaro,
  //       colorObscuro: colorObscuro,
  //     );

  //     for (var segmento in segmentosRam) {
  //       if (segmento.espacioDisponible >= proceso.tamanioTotal) {
  //         // Hay suficiente espacio en este segmento para asignar el proceso
  //         setState(() {
  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += proceso.tamanioTotal;
  //           segmento.espacioDisponible =
  //               segmento.tamanio - segmento.tamanioOcupado;
  //         });
  //         proceso.tamanioAsignado += proceso.tamanioTotal;
  //         setState(() {
  //           procesosActivos.add(proceso);
  //         });
  //         return; // Proceso asignado exitosamente, salir del bucle
  //       } else if (segmento.tamanioOcupado == 0 &&
  //           segmento.tamanio >= proceso.tamanioTotal) {
  //         // El segmento está vacío, pero el proceso no cabe completamente
  //         // Asignar el proceso a este segmento y dividirlo si es necesario
  //         int espacioDisponible = segmento.tamanio - segmento.tamanioOcupado;
  //         int tamanioRestante = proceso.tamanioTotal - proceso.tamanioAsignado;
  //         if (espacioDisponible >= tamanioRestante) {
  //           // Hay suficiente espacio en este segmento para asignar el resto del proceso
  //           setState(() {
  //             segmento.procesos.add(proceso);
  //             segmento.tamanioOcupado += tamanioRestante;
  //             segmento.espacioDisponible =
  //                 segmento.tamanio - segmento.tamanioOcupado;
  //           });
  //           proceso.tamanioAsignado += tamanioRestante;
  //           setState(() {
  //             procesosActivos.add(proceso);
  //           });
  //           return; // Proceso asignado exitosamente, salir del bucle
  //         }
  //       } else if (segmento.espacioDisponible > 0) {
  //         // El proceso no cabe completamente en este segmento, dividirlo
  //         Proceso parteDividida = Proceso(
  //           id: proceso.id,
  //           nombre: proceso.nombre,
  //           tamanioTotal: proceso.tamanioTotal,
  //           colorClaro: proceso.colorClaro,
  //           colorObscuro: proceso.colorObscuro,
  //         );

  //         // Actualizar el proceso original y asignar la parte dividida
  //         setState(() {
  //           // proceso.tamanioTotal = proceso.tamanioAsignado;
  //           proceso.tamanioAsignado = segmento.espacioDisponible;
  //           proceso.tamanioPorAsignar =
  //               proceso.tamanioTotal - segmento.espacioDisponible;

  //           parteDividida.tamanioAsignado = proceso.tamanioAsignado;
  //           parteDividida.tamanioPorAsignar = proceso.tamanioPorAsignar;

  //           segmento.procesos.add(proceso);
  //           segmento.espacioDisponible -= proceso.tamanioAsignado;
  //         });

  //         // Buscar otro segmento para asignar la parte dividida
  //         for (var otroSegmento in segmentosRam) {
  //           if (otroSegmento.espacioDisponible >=
  //               parteDividida.tamanioPorAsignar) {
  //             setState(() {
  //               otroSegmento.procesos.add(parteDividida);
  //               otroSegmento.tamanioOcupado +=
  //                   parteDividida.tamanioTotal - parteDividida.tamanioAsignado;
  //               otroSegmento.espacioDisponible =
  //                   otroSegmento.tamanio - otroSegmento.tamanioOcupado;
  //             });
  //             setState(() {
  //               procesosActivos.add(parteDividida);
  //             });
  //             return; // Proceso asignado exitosamente, salir del bucle
  //           }
  //         }
  //       }
  //     }

  //     // Si llegamos aquí, no se pudo asignar el proceso en su totalidad en ningún segmento
  //     // Mostrar mensaje de error
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error de asignación'),
  //           content: const SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text(
  //                     'No hay suficiente espacio en los segmentos de RAM para asignar el proceso en su totalidad.'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Aceptar'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // void validarNuevoProceso() {
  //   if (_formKeyProceso.currentState?.validate() ?? false) {
  //     final nombreProceso = nombreProcesoController.text;
  //     final tamanioProcesoValue = int.parse(tamanioProceso.split(' => ')[1]);
  //     Color colorClaro = generarColorAleatorioClaro();
  //     Color colorObscuro = generarColorAleatorioObscuro();

  //     Proceso proceso = Proceso(
  //       id: siguienteProcesoId++,
  //       nombre: nombreProceso,
  //       tamanioTotal: tamanioProcesoValue,
  //       colorClaro: colorClaro,
  //       colorObscuro: colorObscuro,
  //     );

  //     int tamanioRestante = proceso.tamanioTotal;

  //     for (var segmento in segmentosRam) {
  //       if (segmento.espacioDisponible >= tamanioRestante) {
  //         // Hay suficiente espacio en este segmento para asignar el proceso
  //         setState(() {
  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += tamanioRestante;
  //           segmento.espacioDisponible =
  //               segmento.tamanio - segmento.tamanioOcupado;
  //         });

  //         proceso.tamanioAsignado += tamanioRestante;
  //         setState(() {
  //           procesosActivos.add(proceso);
  //         });
  //         return; // Proceso asignado exitosamente, salir del bucle
  //       } else if (segmento.espacioDisponible > 0) {
  //         // El proceso no cabe completamente en este segmento, dividirlo
  //         int espacioDisponible = segmento.espacioDisponible;

  //         Proceso parteDividida = Proceso(
  //           id: siguienteProcesoId++,
  //           nombre: nombreProceso,
  //           tamanioTotal: tamanioProcesoValue,
  //           colorClaro: colorClaro,
  //           colorObscuro: colorObscuro,
  //         );

  //         // Actualizar el proceso original y asignar la parte dividida
  //         setState(() {
  //           proceso.tamanioAsignado += espacioDisponible;
  //           proceso.tamanioPorAsignar -= espacioDisponible;

  //           parteDividida.tamanioAsignado = espacioDisponible;
  //           parteDividida.tamanioPorAsignar =
  //               tamanioProcesoValue - proceso.tamanioAsignado;

  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += espacioDisponible;
  //           segmento.espacioDisponible -= espacioDisponible;
  //         });

  //         // Buscar otro segmento para asignar la parte dividida
  //         tamanioRestante = parteDividida.tamanioPorAsignar;

  //         if (tamanioRestante == 0) {
  //           setState(() {
  //             procesosActivos.add(parteDividida);
  //           });
  //           return; // Proceso asignado exitosamente, salir del bucle
  //         }
  //       }
  //     }

  //     // Si llegamos aquí, no se pudo asignar el proceso en su totalidad en ningún segmento
  //     // Mostrar mensaje de error
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error de asignación'),
  //           content: const SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text(
  //                     'No hay suficiente espacio en los segmentos de RAM para asignar el proceso en su totalidad.'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Aceptar'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // void validarNuevoProceso() {
  //   if (_formKeyProceso.currentState?.validate() ?? false) {
  //     final nombreProceso = nombreProcesoController.text;
  //     final tamanioProcesoValue = int.parse(tamanioProceso.split(' => ')[1]);
  //     Color colorClaro = generarColorAleatorioClaro();
  //     Color colorObscuro = generarColorAleatorioObscuro();

  //     Proceso proceso = Proceso(
  //       id: siguienteProcesoId++,
  //       nombre: nombreProceso,
  //       tamanioTotal: tamanioProcesoValue,
  //       colorClaro: colorClaro,
  //       colorObscuro: colorObscuro,
  //     );

  //     int tamanioRestante = proceso.tamanioTotal;

  //     // Intentar asignar el proceso en la RAM
  //     for (var segmento in segmentosRam) {
  //       if (segmento.espacioDisponible >= tamanioRestante) {
  //         // Hay suficiente espacio en este segmento para asignar el proceso
  //         setState(() {
  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += tamanioRestante;
  //           segmento.espacioDisponible =
  //               segmento.tamanio - segmento.tamanioOcupado;
  //         });

  //         proceso.tamanioAsignado += tamanioRestante;
  //         setState(() {
  //           procesosActivos.add(proceso);
  //         });
  //         return; // Proceso asignado exitosamente, salir del bucle
  //       } else if (segmento.espacioDisponible > 0) {
  //         // El proceso no cabe completamente en este segmento, dividirlo
  //         int espacioDisponible = segmento.espacioDisponible;

  //         Proceso parteDividida = Proceso(
  //           id: siguienteProcesoId++,
  //           nombre: nombreProceso,
  //           tamanioTotal: tamanioProcesoValue,
  //           colorClaro: colorClaro,
  //           colorObscuro: colorObscuro,
  //         );

  //         // Actualizar el proceso original y asignar la parte dividida
  //         setState(() {
  //           proceso.tamanioAsignado += espacioDisponible;
  //           proceso.tamanioPorAsignar -= espacioDisponible;

  //           parteDividida.tamanioAsignado = espacioDisponible;
  //           parteDividida.tamanioPorAsignar =
  //               tamanioProcesoValue - proceso.tamanioAsignado;

  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += espacioDisponible;
  //           segmento.espacioDisponible -= espacioDisponible;
  //         });

  //         // Buscar otro segmento para asignar la parte dividida
  //         tamanioRestante = parteDividida.tamanioPorAsignar;

  //         if (tamanioRestante == 0) {
  //           setState(() {
  //             procesosActivos.add(parteDividida);
  //           });
  //           return; // Proceso asignado exitosamente, salir del bucle
  //         }
  //       }
  //     }

  //     // Si llegamos aquí, no se pudo asignar el proceso en su totalidad en la RAM
  //     // Intentar asignar el proceso en la memoria virtual
  //     for (var segmento in segmentosVirtual) {
  //       if (segmento.espacioDisponible >= tamanioRestante) {
  //         // Hay suficiente espacio en este segmento para asignar el proceso
  //         setState(() {
  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += tamanioRestante;
  //           segmento.espacioDisponible =
  //               segmento.tamanio - segmento.tamanioOcupado;
  //         });

  //         proceso.tamanioAsignado += tamanioRestante;
  //         setState(() {
  //           procesosActivos.add(proceso);
  //         });
  //         return; // Proceso asignado exitosamente, salir del bucle
  //       } else if (segmento.espacioDisponible > 0) {
  //         // El proceso no cabe completamente en este segmento, dividirlo
  //         int espacioDisponible = segmento.espacioDisponible;

  //         Proceso parteDividida = Proceso(
  //           id: siguienteProcesoId++,
  //           nombre: nombreProceso,
  //           tamanioTotal: tamanioProcesoValue,
  //           colorClaro: colorClaro,
  //           colorObscuro: colorObscuro,
  //         );

  //         // Actualizar el proceso original y asignar la parte dividida
  //         setState(() {
  //           proceso.tamanioAsignado += espacioDisponible;
  //           proceso.tamanioPorAsignar -= espacioDisponible;

  //           parteDividida.tamanioAsignado = espacioDisponible;
  //           parteDividida.tamanioPorAsignar =
  //               tamanioProcesoValue - proceso.tamanioAsignado;

  //           segmento.procesos.add(proceso);
  //           segmento.tamanioOcupado += espacioDisponible;
  //           segmento.espacioDisponible -= espacioDisponible;
  //         });

  //         // Buscar otro segmento para asignar la parte dividida
  //         tamanioRestante = parteDividida.tamanioPorAsignar;

  //         if (tamanioRestante == 0) {
  //           setState(() {
  //             procesosActivos.add(parteDividida);
  //           });
  //           return; // Proceso asignado exitosamente, salir del bucle
  //         }
  //       }
  //     }

  //     // Si llegamos aquí, no se pudo asignar el proceso en su totalidad ni en la RAM ni en la memoria virtual
  //     // Mostrar mensaje de error
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Segmentos Insuficientes'),
  //           content: const SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text('¿Asignar proceso a la lista de espera?'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Cancelar'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: const Text('Aceptar'),
  //               onPressed: () {
  //                 // Agregar el proceso a la lista de espera
  //                 setState(() {
  //                   procesosEnEspera.add(proceso);
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void terminarProcesoActivo(Proceso proceso) {
    // Eliminar el proceso de todos los segmentos


    for (var segmento in segmentosRam) {
      for (Proceso procesoA in segmento.procesos) {
        if (proceso.id == procesoA.id) {
          setState(() {
            segmento.procesos.remove(procesoA);
            segmento.espacioOcupado -= procesoA.espacioAsignadoEnProceso;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesosActivos.remove(procesoA);
          });
        }
      }
    }

    for (var segmento in segmentosVirtual) {
      for (Proceso procesoA in segmento.procesos) {
        if (proceso.id == procesoA.id) {
          setState(() {
            segmento.procesos.remove(procesoA);
            segmento.espacioOcupado -= procesoA.espacioAsignadoEnProceso;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesosActivos.remove(procesoA);
          });
        }
      }
    }


    // Proceso procesoEnSegmento = proceso;
    // procesoEnSegmento.espacioAsignadoEnProceso = 0;

    // for (var segmento in segmentosRam) {
    //   for (Proceso procesoA in segmento.procesos) {
    //     if (proceso.id == procesoA.id) {
    //       procesoEnSegmento = procesoA;
    //       break; // Termina la búsqueda cuando se encuentra el proceso
    //     }
    //   }
    //   if (segmento.procesos.contains(procesoEnSegmento)) {
    //     setState(() {
    //       segmento.procesos.remove(procesoEnSegmento);
    //       segmento.espacioOcupado -= procesoEnSegmento.espacioAsignadoEnProceso;
    //       segmento.espacioDisponible =
    //           segmento.tamanio - segmento.espacioOcupado;
    //     });
    //   }
    // }

    // for (var segmento in segmentosVirtual) {
    //   for (Proceso procesoA in segmento.procesos) {
    //     if (proceso.id == procesoA.id) {
    //       procesoEnSegmento = procesoA;
    //       break; // Termina la búsqueda cuando se encuentra el proceso
    //     }
    //   }
    //   if (segmento.procesos.contains(procesoEnSegmento)) {
    //     setState(() {
    //       segmento.procesos.remove(procesoEnSegmento);
    //       segmento.espacioOcupado -= procesoEnSegmento.espacioAsignadoEnProceso;
    //       segmento.espacioDisponible =
    //           segmento.tamanio - segmento.espacioOcupado;
    //     });
    //   }
    // }

    // Recorrer los procesos hacia arriba en los segmentos
    // for (var segmento in segmentosRam) {
    //   for (var otroProceso in segmento.procesos) {
    //     if (otroProceso.id > proceso.id) {
    //       setState(() {
    //         otroProceso.id--;
    //       });
    //     }
    //   }
    // }

    // for (var segmento in segmentosVirtual) {
    //   for (var otroProceso in segmento.procesos) {
    //     if (otroProceso.id > proceso.id) {
    //       setState(() {
    //         otroProceso.id--;
    //       });
    //     }
    //   }
    // }

    // Eliminar el proceso de la lista de procesos activos
    setState(() {
      procesosActivos.remove(proceso);
      procesosTerminados.add(proceso);
    });

    // Si hay procesos en espera, intentar asignarlos
    if (procesosEnEspera.isNotEmpty) {
      // ejecutarProcesoEnEspera();
    }
  }

  Proceso obtenerProcesoMenorEspera(List<Proceso> listaEspera) {
    Proceso procesoMenor = listaEspera[0];

    for (var proceso in listaEspera) {
      if (proceso.tamanioTotal < procesoMenor.tamanioTotal) {
        procesoMenor = proceso;
      }
    }

    return procesoMenor;
  }

  void ejecutarProcesoEnEspera() {
    if (procesosEnEspera.isNotEmpty) {
      Proceso procesoEspera = obtenerProcesoMenorEspera(procesosEnEspera);

      for (var segmento in segmentosRam) {
        int tamanioRestante =
            procesoEspera.tamanioTotal - procesoEspera.espacioAsignado;
        if (segmento.espacioDisponible >= tamanioRestante) {
          // Hay suficiente espacio en este segmento para asignar el proceso
          setState(() {
            segmento.procesos.add(procesoEspera);
            segmento.espacioOcupado += tamanioRestante;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
          });

          procesoEspera.espacioAsignado += tamanioRestante;
          setState(() {
            procesosActivos.add(procesoEspera);
            procesosEnEspera.remove(procesoEspera);
          });

          if (procesosEnEspera.isNotEmpty) {
            ejecutarProcesoEnEspera();
          }
        } else if (segmento.espacioDisponible > 0) {
          // El proceso no cabe completamente en este segmento, dividirlo
          int espacioDisponible = segmento.espacioDisponible;

          Proceso parteDividida = Proceso(
              id: siguienteProcesoId++,
              nombre: procesoEspera.nombre,
              tamanioTotal: procesoEspera.tamanioTotal,
              colorClaro: procesoEspera.colorClaro,
              colorObscuro: procesoEspera.colorObscuro,
              espacioSinAsignar: procesoEspera.tamanioTotal);

          // Actualizar el proceso original y asignar la parte dividida
          setState(() {
            procesoEspera.espacioAsignado += espacioDisponible;
            procesoEspera.espacioSinAsignar -= espacioDisponible;

            parteDividida.espacioAsignado = espacioDisponible;
            parteDividida.espacioSinAsignar =
                procesoEspera.tamanioTotal - procesoEspera.espacioAsignado;

            segmento.procesos.add(procesoEspera);
            segmento.espacioOcupado += espacioDisponible;
            segmento.espacioDisponible -= espacioDisponible;
          });

          // Buscar otro segmento para asignar la parte dividida
          tamanioRestante = parteDividida.espacioSinAsignar;

          if (tamanioRestante == 0) {
            setState(() {
              procesosActivos.add(parteDividida);
              procesosEnEspera.remove(procesoEspera);
            });
            if (procesosEnEspera.isNotEmpty) {
              ejecutarProcesoEnEspera();
            }
          }
        }
      }

      // Si llegamos aquí, no se pudo asignar el proceso en su totalidad en la RAM
      for (var segmento in segmentosVirtual) {
        int tamanioRestante =
            procesoEspera.tamanioTotal - procesoEspera.espacioAsignado;
        if (segmento.espacioDisponible >= tamanioRestante) {
          // Hay suficiente espacio en este segmento para asignar el proceso
          setState(() {
            segmento.procesos.add(procesoEspera);
            segmento.espacioOcupado += tamanioRestante;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
          });

          procesoEspera.espacioAsignado += tamanioRestante;
          setState(() {
            procesosActivos.add(procesoEspera);
            procesosEnEspera.remove(procesoEspera);
          });
          if (procesosEnEspera.isNotEmpty) {
            ejecutarProcesoEnEspera();
          }
        } else if (segmento.espacioDisponible > 0) {
          // El proceso no cabe completamente en este segmento, dividirlo
          int espacioDisponible = segmento.espacioDisponible;

          Proceso parteDividida = Proceso(
              id: siguienteProcesoId++,
              nombre: procesoEspera.nombre,
              tamanioTotal: procesoEspera.tamanioTotal,
              colorClaro: procesoEspera.colorClaro,
              colorObscuro: procesoEspera.colorObscuro,
              espacioSinAsignar: procesoEspera.tamanioTotal);

          // Actualizar el proceso original y asignar la parte dividida
          setState(() {
            procesoEspera.espacioAsignado += espacioDisponible;
            procesoEspera.espacioSinAsignar -= espacioDisponible;

            parteDividida.espacioAsignado = espacioDisponible;
            parteDividida.espacioSinAsignar =
                procesoEspera.tamanioTotal - procesoEspera.espacioAsignado;

            segmento.procesos.add(procesoEspera);
            segmento.espacioOcupado += espacioDisponible;
            segmento.espacioDisponible -= espacioDisponible;
          });

          // Buscar otro segmento para asignar la parte dividida
          tamanioRestante = parteDividida.espacioSinAsignar;

          if (tamanioRestante == 0) {
            setState(() {
              procesosActivos.add(parteDividida);
              procesosEnEspera.remove(procesoEspera);
            });
            if (procesosEnEspera.isNotEmpty) {
              ejecutarProcesoEnEspera();
            } // Proceso asignado exitosamente, salir del bucle
          }
        }
      }

      // Si llegamos aquí, no se pudo asignar el proceso en su totalidad ni en la RAM ni en la memoria virtual
      setState(() {
        eliminarProcesoDeSegmentos(procesoEspera.id);
      });

      return;
    }
  }

  void validarNuevoProceso() {
    if (_formKeyProceso.currentState?.validate() ?? false) {
      final nombreProceso = nombreProcesoController.text;
      final tamanioProcesoValue = int.parse(tamanioProceso.split(' => ')[1]);
      Color colorClaro = generarColorAleatorioClaro();
      Color colorObscuro = generarColorAleatorioObscuro();

      Proceso proceso = Proceso(
          id: siguienteProcesoId++,
          nombre: nombreProceso,
          tamanioTotal: tamanioProcesoValue,
          colorClaro: colorClaro,
          colorObscuro: colorObscuro,
          espacioSinAsignar: tamanioProcesoValue);

      for (var segmento in segmentosRam) {
        int tamanioRestante = proceso.tamanioTotal - proceso.espacioAsignado;

        Proceso procesoClone = Proceso(
            id: proceso.id,
            nombre: proceso.nombre,
            tamanioTotal: proceso.tamanioTotal,
            colorClaro: proceso.colorClaro,
            colorObscuro: proceso.colorObscuro,
            espacioSinAsignar: proceso.espacioSinAsignar
            // ...
            );

        if (segmento.espacioDisponible >= tamanioRestante) {
          // Hay suficiente espacio en este segmento para asignar el proceso
          setState(() {
            segmento.espacioOcupado += tamanioRestante;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesoClone.espacioAsignadoEnProceso = tamanioRestante;
            segmento.procesos.add(procesoClone);
          });

          proceso.espacioAsignado += tamanioRestante;
          proceso.espacioSinAsignar =
              proceso.tamanioTotal - proceso.espacioAsignado;
          setState(() {
            procesosActivos.add(proceso);
          });
          return; // Proceso asignado exitosamente, salir del bucle
        } else if (segmento.espacioDisponible > 0) {
          // El proceso no cabe completamente en este segmento, dividirlo
          int espacioDisponible = segmento.espacioDisponible;

          Proceso parteDividida = Proceso(
              id: proceso.id,
              nombre: nombreProceso,
              tamanioTotal: tamanioProcesoValue,
              colorClaro: colorClaro,
              colorObscuro: colorObscuro,
              espacioSinAsignar: tamanioProcesoValue);

          Proceso procesoClone = Proceso(
              id: proceso.id,
              nombre: proceso.nombre,
              tamanioTotal: proceso.tamanioTotal,
              colorClaro: proceso.colorClaro,
              colorObscuro: proceso.colorObscuro,
              espacioSinAsignar: proceso.espacioSinAsignar
              // ...
              );

          // Actualizar el proceso original y asignar la parte dividida
          setState(() {
            proceso.espacioAsignado += espacioDisponible;
            proceso.espacioSinAsignar -= espacioDisponible;
            parteDividida.espacioAsignado = espacioDisponible;
            parteDividida.espacioSinAsignar =
                tamanioProcesoValue - proceso.espacioAsignado;

            procesoClone.espacioAsignadoEnProceso = espacioDisponible;
            segmento.procesos.add(procesoClone);
            segmento.espacioOcupado += espacioDisponible;
            segmento.espacioDisponible -= espacioDisponible;
          });

          // Buscar otro segmento para asignar la parte dividida
          tamanioRestante = parteDividida.espacioSinAsignar;

          if (tamanioRestante == 0) {
            setState(() {
              procesosActivos.add(parteDividida);
            });
            return; // Proceso asignado exitosamente, salir del bucle
          }
        }
      }

      // Si llegamos aquí, no se pudo asignar el proceso en su totalidad en la RAM
      for (var segmento in segmentosVirtual) {
        int tamanioRestante = proceso.tamanioTotal - proceso.espacioAsignado;

        Proceso procesoClone = Proceso(
            id: proceso.id,
            nombre: proceso.nombre,
            tamanioTotal: proceso.tamanioTotal,
            colorClaro: proceso.colorClaro,
            colorObscuro: proceso.colorObscuro,
            espacioSinAsignar: proceso.espacioSinAsignar
            // ...
            );

        if (segmento.espacioDisponible >= tamanioRestante) {
          // Hay suficiente espacio en este segmento para asignar el proceso
          setState(() {
            segmento.espacioOcupado += tamanioRestante;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesoClone.espacioAsignadoEnProceso = tamanioRestante;
            segmento.procesos.add(procesoClone);
          });

          proceso.espacioAsignado += tamanioRestante;
          proceso.espacioSinAsignar =
              proceso.tamanioTotal - proceso.espacioAsignado;
          setState(() {
            procesosActivos.add(proceso);
          });
          return; // Proceso asignado exitosamente, salir del bucle
        } else if (segmento.espacioDisponible > 0) {
          // El proceso no cabe completamente en este segmento, dividirlo
          int espacioDisponible = segmento.espacioDisponible;

          Proceso parteDividida = Proceso(
              id: siguienteProcesoId++,
              nombre: nombreProceso,
              tamanioTotal: tamanioProcesoValue,
              colorClaro: colorClaro,
              colorObscuro: colorObscuro,
              espacioSinAsignar: tamanioProcesoValue);

          Proceso procesoClone = Proceso(
              id: proceso.id,
              nombre: proceso.nombre,
              tamanioTotal: proceso.tamanioTotal,
              colorClaro: proceso.colorClaro,
              colorObscuro: proceso.colorObscuro,
              espacioSinAsignar: proceso.espacioSinAsignar
              // ...
              );

          // Actualizar el proceso original y asignar la parte dividida
          setState(() {
            proceso.espacioAsignado += espacioDisponible;
            proceso.espacioSinAsignar -= espacioDisponible;
            parteDividida.espacioAsignado = espacioDisponible;
            parteDividida.espacioSinAsignar =
                tamanioProcesoValue - proceso.espacioAsignado;

            procesoClone.espacioAsignadoEnProceso = espacioDisponible;
            segmento.procesos.add(procesoClone);
            segmento.espacioOcupado += espacioDisponible;
            segmento.espacioDisponible -= espacioDisponible;
          });

          // Buscar otro segmento para asignar la parte dividida
          tamanioRestante = parteDividida.espacioSinAsignar;

          if (tamanioRestante == 0) {
            setState(() {
              procesosActivos.add(parteDividida);
            });
            return; // Proceso asignado exitosamente, salir del bucle
          }
        }
      }

      // Si llegamos aquí, no se pudo asignar el proceso en su totalidad ni en la RAM ni en la memoria virtual
      setState(() {
        eliminarProcesoDeSegmentos(proceso.id);
      });
      // Mostrar mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Segmentos Insuficientes'),
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
                    procesosEnEspera.add(proceso);
                    // eliminarProcesoDeSegmentos(proceso.id);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void eliminarProcesoDeSegmentos(int idProceso) {
    for (var segmento in segmentosRam) {
      for (Proceso procesoA in segmento.procesos) {
        if (idProceso == procesoA.id) {
          setState(() {
            segmento.procesos.remove(procesoA);
            segmento.espacioOcupado -= procesoA.espacioAsignadoEnProceso;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesosActivos.remove(procesoA);
          });
        }
      }
    }

    for (var segmento in segmentosVirtual) {
      for (Proceso procesoA in segmento.procesos) {
        if (idProceso == procesoA.id) {
          setState(() {
            segmento.procesos.remove(procesoA);
            segmento.espacioOcupado -= procesoA.espacioAsignadoEnProceso;
            segmento.espacioDisponible =
                segmento.tamanio - segmento.espacioOcupado;
            procesosActivos.remove(procesoA);
          });
        }
      }
    }
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

  void cancelarProcesoEnEspera(int procesoId) {
    setState(() {
      Proceso procesoEnEspera =
          procesosEnEspera.firstWhere((proceso) => proceso.id == procesoId);
      procesosCancelados.add(procesoEnEspera);
      procesosEnEspera.removeWhere((proceso) => proceso.id == procesoId);
    });
  }

  void actualizarMemoria() {
    // memoriaTotal = marcos.length * marcos[0].tamanio;
    // int marcosOcupados = marcos.where((marco) => marco.proceso != null).length;
    // memoriaOcupada = marcosOcupados * marcos[0].tamanio;
    // memoriaDisponible = memoriaTotal - memoriaOcupada;
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

  Future<void> mostrarDialogoConfirmacionTerminarProceso(
      Proceso proceso) async {
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
                terminarProcesoActivo(proceso);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ElevatedButton reiniciarSegmentacion() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Color(0xffff4900)), // Fondo naranja
        foregroundColor:
            MaterialStateProperty.all<Color>(Colors.white), // Texto blanco
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Reiniciar Paginación'),
              content: const Text(
                  '¿Estás seguro de que deseas reiniciar la paginación?\nSe perderán todos los datos actuales.'),
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
                    setState(() {
                      tamanioSegmentosRam = '2⁶ => 64';
                      tamanioSegmentosVirtual = '2⁶ => 64';
                      tamanioSegmentosRamyVirtual = '2⁶ => 64';
                      tamanioProceso = '2⁶ => 64';

                      segmentosRam = [];
                      segmentosVirtual = [];
                      procesosActivos = [];
                      procesosEnEspera = [];
                      procesosTerminados = [];
                      procesosCancelados = [];

                      memoriaTotal = 0;
                      memoriaDisponible = 0;
                      memoriaOcupada = 0;
                      memoriaVirtual = 0;
                      siguienteProcesoId = 1;

                      numeroDeSegmentosRamControlador.clear();
                      nombreProcesoController.clear();

                      entradaDeSegmentosHabilitado = true;
                      entradaDeProcesoHablitados = false;

                      segmentoId = 1;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('Reiniciar'),
    );
  }

  //
}

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
