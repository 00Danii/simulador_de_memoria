import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

class Paginacion extends StatefulWidget {
  const Paginacion({super.key});

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
  List<Proceso> procesos = [];
  List<Proceso> procesosEnEspera = [];

  int memoriaTotal = 0;
  int memoriaDisponible = 0;
  int memoriaOcupada = 0;

  int siguienteProcesoId = 1;

  void actualizarMemoria() {
    // Calcular memoria total
    memoriaTotal = marcos.length * marcos[0].tamanio;

    // Calcular marcos ocupados
    int marcosOcupados = marcos.where((marco) => marco.proceso != null).length;

    // Calcular memoria ocupada
    memoriaOcupada = marcosOcupados * marcos[0].tamanio;

    // Calcular memoria disponible
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
        siguienteProcesoId = 1;
      });
    }
  }

  void limpiarProcesosActivos() {
    setState(() {
      procesos.clear();
    });
  }

  void limpiarProcesosEspera() {
    setState(() {
      procesosEnEspera.clear();
    });
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
            procesos.add(Proceso(
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
              procesos.add(Proceso(
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
    setState(
      () {
        if (procesos.any((proceso) => proceso.id == procesoId)) {
          marcos.forEach((marco) {
            if (marco.proceso != null && marco.procesoId == procesoId) {
              marco.proceso = null;
              marco.procesoId = 0; // Resetea el procesoId
            }
          });

          procesos.removeWhere((proceso) => proceso.id == procesoId);
        }
      },
    );
  }

  void eliminarProcesoEnEspera(int procesoId) {
    setState(
      () {
        // if (procesosEnEspera.any((proceso) => proceso.id == procesoId)) {
        //   marcos.forEach((marco) {
        //     if (marco.proceso != null && marco.procesoId == procesoId) {
        //       marco.proceso = null;
        //       marco.procesoId = 0; // Resetea el procesoId
        //     }
        //   });

        //   procesosEnEspera.removeWhere((proceso) => proceso.id == procesoId);
        // }

        procesosEnEspera.removeWhere((proceso) => proceso.id == procesoId);
      },
    );
  }

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
            SizedBox(height: 40),
            entradasDeProcesos(),
            SizedBox(height: 40),
            if (marcos.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 15.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Marco de Paginación: ${marcos.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ...marcos.map(
                          (marco) {
                            return InkWell(
                              onTap: () {
                                if (marco.proceso != null) {
                                  eliminarProceso(marco.procesoId);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          tema ? Colors.white : Colors.black),
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
                  ),

                  // SizedBox(width: 20),

                  SizedBox(
                    width: 25.w,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Procesos Activos: ${procesos.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 19),
                        Align(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !tema ? Colors.black : Colors.white),
                            ),
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Tamaño')),
                              ],
                              rows: procesos.map<DataRow>(
                                (Proceso proceso) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              eliminarProceso(proceso.id),
                                          child: Center(
                                              child:
                                                  Text(proceso.id.toString())),
                                        ),
                                      ),
                                      DataCell(
                                        InkWell(
                                            onTap: () =>
                                                eliminarProceso(proceso.id),
                                            child: Center(
                                                child: Text(proceso.nombre))),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () =>
                                              eliminarProceso(proceso.id),
                                          child: Center(
                                              child: Text(
                                                  proceso.tamanio.toString())),
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
                    ),
                  ),

                  // SizedBox(width: 10),

                  SizedBox(
                    width: 25.w,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Procesos en Espera: ${procesosEnEspera.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 19),
                        Align(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: !tema ? Colors.black : Colors.white),
                            ),
                            child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Tamaño')),
                              ],
                              rows: procesosEnEspera
                                  .map<DataRow>((Proceso proceso) {
                                return DataRow(cells: <DataCell>[
                                  DataCell(
                                    InkWell(
                                        onTap: () =>
                                            eliminarProcesoEnEspera(proceso.id),
                                        child: Center(
                                            child:
                                                Text(proceso.id.toString()))),
                                  ),
                                  DataCell(
                                    InkWell(
                                        onTap: () =>
                                            eliminarProcesoEnEspera(proceso.id),
                                        child: Center(
                                            child: Text(proceso.nombre))),
                                  ),
                                  DataCell(
                                    InkWell(
                                      onTap: () =>
                                          eliminarProcesoEnEspera(proceso.id),
                                      child: Center(
                                          child:
                                              Text(proceso.tamanio.toString())),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(width: 20),
                  // Espaciado entre marcos y texto "Memoria Total"
                  Expanded(
                    child: Align(
                      // alignment: Alignment.topLeft,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Memoria Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$memoriaTotal'),
                          SizedBox(height: 10),
                          Text(
                            'Memoria Disponible',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$memoriaDisponible'),
                          SizedBox(height: 10),
                          Text(
                            'Memoria Ocupada',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$memoriaOcupada'),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Form entradasDeProcesos() {
    return Form(
      key: _formKeyProceso,
      child: Column(
        children: <Widget>[
          Row(
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: nombreProcesoController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
              SizedBox(width: 10),
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
                  decoration: InputDecoration(
                    labelText: 'Tamaño del proceso',
                  ),
                ),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                onPressed: validarNuevoProceso,
                child: Text('Aceptar'),
              ),
              SizedBox(width: 50),
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
          Row(
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
          SizedBox(height: 10),
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
                  decoration: InputDecoration(
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
              SizedBox(width: 10),
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
                  decoration: InputDecoration(
                    labelText: 'Tamaño de cada marco',
                  ),
                ),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                onPressed: validarNumeroDeMarcos,
                child: Text('Aceptar'),
              ),
              SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }
}
