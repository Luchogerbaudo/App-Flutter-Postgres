// Menu usado en vistas, menos en main
// En el menu es todo lo mismo, navigator a las vistas desde las opciones del menu
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_postgres/agregados/sugerencias.dart';
import 'package:flutter_postgres/mantenimiento/agregarsolicitud.dart';
import 'package:flutter_postgres/home/inicio.dart';
import 'package:flutter_postgres/main.dart';
import 'package:flutter_postgres/calidad/ncporvalidar.dart';
import 'package:flutter_postgres/calidad/ncsingestion.dart';
import 'package:flutter_postgres/mantenimiento/sporvalidar.dart';
import 'package:flutter_postgres/mantenimiento/sporatender.dart';
import 'package:flutter_postgres/mantenimiento/solporatender.dart';
import 'package:flutter_postgres/agregados/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colores.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado del Drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colores.azulOscuro,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7.0, left: 3.0),
                  child: const Text(
                    'Macoser SGM',
                    style: TextStyle(
                      color: Colores.blanco,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.width * 0.10),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 7.0, left: 3.0),
                      child: Row(
                        children: [
                          Text(
                            '$nombreUser $apellidoUser',
                            style: const TextStyle(
                              color: Colores.blanco,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ir a Inicio
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(
                      milliseconds: 500), // Duración de la animación
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const InicioPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
          ),

          // Ir a Mantenimiento
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'Mantenimiento',
              style: TextStyle(),
            ),
            children: [
              // Nueva Solicitud de Servicio
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        'Nueva solicitud de servicio',
                        style: TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ServiciosPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              // Servicios por Atender
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Servicios por atender: $indServiciosPorAtender',
                        style: const TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SPorAtender(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              // Servicios por Validar
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Servicios por validar: $indServiciosPorValidar',
                        style: const TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SPorValidar(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              // Solicitudes por Atender
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Solicitudes por atender: $indSolicitudesPorAtender',
                        style: const TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SolPorAtender(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          // Ir a Calidad
          ExpansionTile(
            leading: const Icon(Icons.check),
            title: const Text(
              'Calidad',
              style: TextStyle(),
            ),
            children: [
              // NC sin gestión
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'NC sin gestión: $indNoConfSinGestion',
                        style: const TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NCSinGestion(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              // NC por validar
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  margin: const EdgeInsets.only(left: 36.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'NC por validar: $indNoConfPorValidar',
                        style: const TextStyle(color: Colores.grisOscuro),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                        milliseconds: 500,
                      ),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NCPorValidar(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          // Ir a Sugerencias
          ListTile(
            leading: const Icon(Icons.construction),
            title: const Text(
              'Sugerencias',
              style: TextStyle(),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(
                    milliseconds: 500,
                  ),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const Sugerencia(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Cerrando sesión...',
                      style: TextStyle(),
                    ),
                    content: const Text(
                      '¿Cerrar sesión?',
                      style: TextStyle(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No.',
                          style: TextStyle(),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Si cerramos sesión, limpiamos los sharedpreferences
                          Navigator.of(context).pop();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          idUser = '';
                          nombreUser = '';
                          apellidoUser = '';
                          emailUser = '';
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const MyApp(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        child: const Text(
                          'Sí.',
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // Cerrar aplicación
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text(
              'Cerrar app',
              style: TextStyle(),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Cerrando aplicación...',
                      style: TextStyle(),
                    ),
                    content: const Text(
                      '¿Cerrar app?',
                      style: TextStyle(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'No. 😁',
                          style: TextStyle(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          FlutterExitApp.exitApp();
                        },
                        child: const Text(
                          'Sí. 😭',
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
