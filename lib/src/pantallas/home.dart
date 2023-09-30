import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:simulador_de_memoria/src/menu/menu.dart';
import 'package:simulador_de_memoria/src/pantallas/paginas.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        final tema = (Theme.of(context).brightness == Brightness.dark);
        int contadorDePulsaciones = 0;
        return Scaffold(
          key: _key,
          appBar: AppBar(
            backgroundColor: tema ? const Color.fromARGB(255, 0, 0, 0) : null,
            title: const Text("Simulador de Memoria"),
            // leading: IconButton(
            //   onPressed: () {
            //     // if (!Platform.isAndroid && !Platform.isIOS) {
            //     //   _controller.setExtended(true);
            //     // }
            //     _key.currentState?.openDrawer();
            //   },
            //   icon: const Icon(Icons.menu),
            // ),
            actions: [
              IconButton(
                onPressed: () {
                  EasyDynamicTheme.of(context).changeTheme(
                      dark: !(Theme.of(context).brightness == Brightness.dark));
                },
                icon: Image(
                  image: (Theme.of(context).brightness == Brightness.dark)
                      ? const AssetImage("assets/iconos/obscuro.png")
                      : const AssetImage("assets/iconos/blanco.png"),
                ),
                iconSize: 40,
              ),
            ],
          ),
          // drawer: Menu(controller: _controller),
          body: WillPopScope(
            onWillPop: () async {
              if (contadorDePulsaciones < 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Center(
                      child: Text(
                        'Presione nuevamente para salir.',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
                contadorDePulsaciones++;

                // Reiniciar el contador después de un cierto tiempo
                Future.delayed(const Duration(seconds: 2),
                    () => contadorDePulsaciones = 0);
                return false;
              } else {
                // Realizar cualquier acción adicional antes de salir de la aplicación
                //Cerrar la app
                SystemNavigator.pop();
                return true;
              }
            },
            child: Row(
              children: [
                if (!isSmallScreen) Menu(controller: _controller),
                Expanded(
                  child: Center(
                    child: Paginas(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Bootom navigation
          // bottomNavigationBar: (isSmallScreen)
          //     ? MenuBottom(controller: _controller,
          //       )
          //     : null,
        );
      },
    );
  }

  // CustomNavigationBar menuInferior() {
  //   return CustomNavigationBar(
  //     iconSize: 30.0,
  //     selectedColor: const Color(0xff0c18fb),
  //     strokeColor: const Color(0x300c18fb),
  //     unSelectedColor: Colors.grey[600],
  //     backgroundColor: Colors.white,
  //     borderRadius: Radius.circular(20.0),
  //     items: [
  //       CustomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //       ),
  //       CustomNavigationBarItem(
  //         icon: Icon(
  //           Icons.home,
  //         ),
  //       ),
  //     ],
  //     isFloating: true,
  //   );
  // }
}
