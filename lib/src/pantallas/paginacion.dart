import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Proceso {
  final int id;
  final String nombre;
  final int tamanio;

  Proceso({required this.id, required this.nombre, required this.tamanio});
}

class Marco {
  String? proceso;
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

  int _nextProcesoId = 1;

  void validarNumeroDeMarcos() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        final cantidad = int.parse(numeroDeMarcosControlador.text);
        final tamanioMarco = int.parse(tamanioMarcos.split(' => ')[1]);
        marcos =
            List.generate(cantidad, (index) => Marco(tamanio: tamanioMarco));
      });
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
            int procesoId = _nextProcesoId++;
            procesos.add(Proceso(
                id: procesoId,
                nombre: nombreProceso,
                tamanio: tamanioProcesoValue));
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
                }
              });

              int procesoId = _nextProcesoId++;
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

      if (asignado) {
        nombreProcesoController.clear();
      }

      if (!asignado) {
        print('No hay suficiente espacio para el proceso $nombreProceso');
      }

      print('Guardando nuevo proceso...');
    }
  }

  void liberarMarco(int index) {
    setState(() {
      if (marcos[index].proceso != null) {
        String procesoLiberado = marcos[index].proceso!;
        marcos
            .where((marco) => marco.proceso == procesoLiberado)
            .forEach((marco) {
          marco.proceso = null;
        });

        procesos.removeWhere((proceso) => proceso.nombre == procesoLiberado);
      }
    });
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
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                    widthFactor: .45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: tema ? Colors.white : Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Marco de Paginación',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ...marcos.map((marco) {
                          return GestureDetector(
                            onTap: () {
                              if (marco.proceso != null) {
                                liberarMarco(marcos.indexOf(marco));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: tema ? Colors.white : Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(marco.proceso ?? ''),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    )),
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
