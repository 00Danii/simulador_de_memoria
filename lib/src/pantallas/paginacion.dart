// ignore_for_file: use_key_in_widget_constructors, slash_for_doc_comments

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

  Proceso({required this.id, required this.nombre, required this.tamanio});
}

class Marco {
  String? proceso;
  int procesoId = 0;
  int tamanio;

  Marco({required this.tamanio});
}

/***********************
 * CLASE DE PAGINACION *
 ***********************/
class Paginacion extends StatefulWidget {
  const Paginacion({Key? key});

  @override
  State<Paginacion> createState() => _PaginacionState();
}

class _PaginacionState extends State<Paginacion> {
  TextEditingController numeroDeMarcosControlador = TextEditingController();
  TextEditingController nombreProcesoController = TextEditingController();

  String tamanioMarcos = '2⁶ => 64';
  String tamanioProceso = '2⁶ => 64';

  final _formKey = GlobalKey<FormState>();
  final _formKeyProceso = GlobalKey<FormState>();

  List<Marco> marcos = [];
  List<Proceso> procesosActivos = [];
  List<Proceso> procesosEnEspera = [];
  List<Proceso> procesosTerminados = [];
  List<Proceso> procesosCancelados = [];

  int memoriaTotal = 0;
  int memoriaDisponible = 0;
  int memoriaOcupada = 0;
  int siguienteProcesoId = 1;

  @override
  Widget build(BuildContext context) {
    bool tema = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: tema ? const Color.fromARGB(255, 0, 0, 0) : null,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            entradasDeMarco(),
            const SizedBox(height: 40),
            entradasDeProcesos(),
            const SizedBox(height: 40),
            if (marcos.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  marcoPaginacionPantalla(tema),
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
                      ],
                    ),
                  ),
                  informacionMemoria(),
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

  Expanded informacionMemoria() {
    return Expanded(
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
              border: Border.all(color: !tema ? Colors.black : Colors.white),
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
                        Center(child: Text(proceso.id.toString())),
                      ),
                      DataCell(
                        Center(child: Text(proceso.nombre)),
                      ),
                      DataCell(
                        Center(child: Text(proceso.tamanio.toString())),
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
              border: Border.all(color: !tema ? Colors.black : Colors.white),
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
                          Proceso procesoEnEspera = procesosEnEspera.firstWhere(
                              (proceso) => proceso.id == proceso.id);
                          mostrarDialogoConfirmacionCancelar(proceso.id);
                          procesosCancelados.add(procesoEnEspera);
                        },
                        child: Center(child: Text(proceso.id.toString()))),
                  ),
                  DataCell(
                    InkWell(
                        onTap: () {
                          Proceso procesoEnEspera = procesosEnEspera.firstWhere(
                              (proceso) => proceso.id == proceso.id);
                          mostrarDialogoConfirmacionCancelar(proceso.id);
                          procesosCancelados.add(procesoEnEspera);
                          procesosCancelados.add(procesoEnEspera);
                        },
                        child: Center(child: Text(proceso.nombre))),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () {
                        Proceso procesoEnEspera = procesosEnEspera
                            .firstWhere((proceso) => proceso.id == proceso.id);
                        procesosCancelados.add(procesoEnEspera);
                        mostrarDialogoConfirmacionCancelar(proceso.id);
                        procesosCancelados.add(procesoEnEspera);
                      },
                      child: Center(child: Text(proceso.tamanio.toString())),
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
              border: Border.all(color: !tema ? Colors.black : Colors.white),
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
                        Center(child: Text(proceso.id.toString())),
                      ),
                      DataCell(
                        Center(child: Text(proceso.nombre)),
                      ),
                      DataCell(
                        Center(child: Text(proceso.tamanio.toString())),
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
              border: Border.all(color: !tema ? Colors.black : Colors.white),
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
                          child: Center(child: Text(proceso.id.toString())),
                        ),
                      ),
                      DataCell(
                        InkWell(
                            onTap: () => mostrarDialogoConfirmacion(proceso.id),
                            child: Center(child: Text(proceso.nombre))),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () => mostrarDialogoConfirmacion(proceso.id),
                          child:
                              Center(child: Text(proceso.tamanio.toString())),
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

  SizedBox marcoPaginacionPantalla(bool tema) {
    return SizedBox(
      width: 15.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Marco de Paginación: ${marcos.where((marco) => marco.proceso != null).length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...marcos.map(
            (marco) {
              return InkWell(
                onTap: () {
                  if (marco.proceso != null) {
                    mostrarDialogoConfirmacion(marco.procesoId);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: tema ? Colors.white : Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(marco.proceso ?? ''),
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
                  final tamanioProcesoValue =
                      int.parse(tamanioProceso.split(' => ')[1]);
                  final nombreProceso = nombreProcesoController.text.trim();
                  tamanioProcesoValue > memoriaTotal && nombreProceso != ""
                      ? confirmacionAgregarProcesoMayorAMemoria()
                      : validarNuevoProceso();
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

  Form entradasDeMarco() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Configuración de Marcos',
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
                  controller: numeroDeMarcosControlador,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Ingresa el número de marcos',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '0') {
                      return 'Por favor ingresa el número de marcos';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tamanioMarcos,
                  onChanged: (String? valorNuevo) {
                    setState(() {
                      tamanioMarcos = valorNuevo!;
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
                    labelText: 'Tamaño de cada marco',
                  ),
                ),
              ),
              const SizedBox(width: 50),
              ElevatedButton(
                onPressed: validarNumeroDeMarcos,
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
    memoriaTotal = marcos.length * marcos[0].tamanio;
    int marcosOcupados = marcos.where((marco) => marco.proceso != null).length;
    memoriaOcupada = marcosOcupados * marcos[0].tamanio;
    memoriaDisponible = memoriaTotal - memoriaOcupada;
  }

  void validarNumeroDeMarcos() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        final cantidad = int.parse(numeroDeMarcosControlador.text);
        final tamanioMarco = int.parse(tamanioMarcos.split(' => ')[1]);
        marcos =
            List.generate(cantidad, (index) => Marco(tamanio: tamanioMarco));
        actualizarMemoria();
        limpiarProcesosActivos();
        limpiarProcesosEspera();
        limpiarProcesosTerminados();
        limpiarProcesosCancelados();
        siguienteProcesoId = 1;
      });
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
      for (var i = 0; i < marcos.length; i++) {
        var marco = marcos[i];
        if (marco.proceso == null) {
          if (proceso.tamanio <= marco.tamanio) {
            setState(() {
              marco.proceso = proceso.nombre;
              marco.procesoId = proceso.id;
              procesosActivos.add(proceso);
              eliminarProcesoEnEspera(proceso.id);
              ejecutarProcesoEnEspera();
            });
            break;
          } else {
            int marcosNecesarios = (proceso.tamanio / marcos[0].tamanio).ceil();

            bool espaciosDisponibles = true;
            for (int j = i; j < i + marcosNecesarios; j++) {
              if (j >= marcos.length || marcos[j].proceso != null) {
                espaciosDisponibles = false;
                break;
              }
            }

            if (espaciosDisponibles) {
              setState(() {
                for (int j = i; j < i + marcosNecesarios; j++) {
                  marcos[j].proceso = proceso.nombre;
                  marcos[j].procesoId = proceso.id;
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

      for (var i = 0; i < marcos.length; i++) {
        var marco = marcos[i];
        if (marco.proceso == null) {
          if (tamanioProcesoValue <= marco.tamanio) {
            setState(() {
              // Asignar proceso completo a un marco
              marco.proceso = nombreProceso;
              asignado = true;
            });
            int procesoId = siguienteProcesoId++;
            procesosActivos.add(Proceso(
                id: procesoId,
                nombre: nombreProceso,
                tamanio: tamanioProcesoValue));
            marco.procesoId = procesoId;
            break;
          } else {
            int marcosNecesarios =
                (tamanioProcesoValue / marcos[0].tamanio).ceil();

            bool espaciosDisponibles = true;
            for (int j = i; j < i + marcosNecesarios; j++) {
              if (j >= marcos.length || marcos[j].proceso != null) {
                espaciosDisponibles = false;
                break;
              }
            }

            if (espaciosDisponibles) {
              setState(() {
                for (int j = i; j < i + marcosNecesarios; j++) {
                  marcos[j].proceso = nombreProceso;
                  marcos[j].procesoId = siguienteProcesoId;
                }
              });

              int procesoId = siguienteProcesoId++;
              procesosActivos.add(Proceso(
                  id: procesoId,
                  nombre: nombreProceso,
                  tamanio: tamanioProcesoValue));
              asignado = true;
              break;
            }
          }
        }
      }

      if (!asignado) {
        // Agregar el proceso a la lista de espera
        setState(() {
          procesosEnEspera.add(Proceso(
              id: siguienteProcesoId++,
              nombre: nombreProceso,
              tamanio: tamanioProcesoValue));
        });
      }

      nombreProcesoController.clear();
      actualizarMemoria();
    }
  }

  void eliminarProceso(int procesoId) {
    setState(() {
      int marcosOcupados = 0;
      if (procesosActivos.any((proceso) => proceso.id == procesoId)) {
        for (var marco in marcos) {
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

        // Liberar marcos y recorrer procesos hacia arriba
        for (int j = 0; j < marcosOcupados; j++) {
          for (int i = 0; i < marcos.length - 1; i++) {
            if (marcos[i].proceso == null) {
              marcos[i] = marcos[i + 1];
              marcos[i + 1] =
                  Marco(tamanio: int.parse(tamanioMarcos.split(' => ')[1]));
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
                eliminarProcesoEnEspera(procesoId);
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
