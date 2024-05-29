// Dashboard de inicio
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_postgres/agregados/colores.dart';
import 'package:flutter_postgres/agregados/menu.dart';
import 'package:flutter_postgres/calidad/ncsingestion.dart';
import 'package:flutter_postgres/mantenimiento/solporatender.dart';
import 'package:flutter_postgres/mantenimiento/sporatender.dart';
import 'package:flutter_postgres/mantenimiento/sporvalidar.dart';
import 'package:flutter_postgres/agregados/variables.dart';
import 'package:flutter_postgres/calidad/ncporvalidar.dart';
import 'package:postgres/postgres.dart';
import '../conexionBaseDeDatos/database.dart';
import '../agregados/notificaciones.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  String errorMessageSPA = '';
  String errorMessageSPV = '';
  String errorMessageSolPA = '';
  String errorMessageNCSG = '';
  String errorMessageNCPV = '';
  late Timer timer;

  bool isLoadingSPA = true;
  bool isLoadingSolPA = true;
  bool isLoadingSPV = true;
  bool isLoadingNCSG = true;
  bool isLoadingNCPV = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      await queryServiciosPorAtender();
      await querySolicitudesPorAtender();
      await queryServiciosPorValidar();
      await queryNoConfSinGestion();
      await queryNoConfPorValidar();
      PostgreSQLConnection connection = await DatabaseHelper.openConnection();
      try {
        await NotificacionesHelper.notificacionMadre(connection);
      } finally {
        await DatabaseHelper.closeConnection(connection);
      }
    });
  }

  // Funcion para mostrar indicador Mantenimiento - Servicios por atender
  Future<void> queryServiciosPorAtender() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await DatabaseHelper.executeQuery(connection,
          'SELECT COUNT(*) AS cantidad_registros FROM servicio WHERE id IN (SELECT "idServicio" FROM "ServicioXUsuario" WHERE "idUser" = $idUser) AND "Realizado" = False AND "Eliminado" IS NULL;');
      if (result.isNotEmpty) {
        setState(() {
          indServiciosPorAtender = result.first.first.toString();
          isLoadingSPA = false; // Datos cargados, establecer isLoading en false
        });
      }
    } catch (e) {
      setState(() {
        errorMessageSPA = 'Error: $e';
        isLoadingSPA =
            false; // Error al cargar datos, establecer isLoading en false
      });
    } finally {
      await DatabaseHelper.closeConnection(connection);
    }
  }

  // Funcion para mostrar indicador Mantenimiento - Servicios por validar
  Future<void> queryServiciosPorValidar() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await DatabaseHelper.executeQuery(connection,
          'SELECT COUNT(*) AS cantidad_registros FROM servicio WHERE "Solicitud_id" IN (SELECT id FROM solicitudservicio WHERE "Emisor_id" = $idUser) AND "Realizado" = False AND "Pendiente" = False AND "Iniciado" = True AND "Validar" = True AND "Eliminado" IS NULL;');
      if (result.isNotEmpty) {
        setState(() {
          indServiciosPorValidar = result.first.first.toString();
          isLoadingSPV = false; // Datos cargados, establecer isLoading en false
        });
      }
    } catch (e) {
      setState(() {
        errorMessageSPV = 'Error: $e';
        isLoadingSPV =
            false; // Error al cargar datos, establecer isLoading en false
      });
    } finally {
      await DatabaseHelper.closeConnection(connection);
    }
  }

  // Funcion para mostrar indicador Mantenimiento - Solicitudes por atender
  Future<void> querySolicitudesPorAtender() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await DatabaseHelper.executeQuery(connection,
          'SELECT distinct count(*) FROM solicitudservicio WHERE solicitudservicio."Sector_id" = $sectorUser AND "Estado" = False AND solicitudservicio."Eliminado" IS NULL AND "Rechazada" = False');
      if (result.isNotEmpty) {
        setState(() {
          indSolicitudesPorAtender = result.first.first.toString();
          isLoadingSolPA =
              false; // Datos cargados, establecer isLoading en false
        });
      }
    } catch (e) {
      setState(() {
        errorMessageSolPA = 'Error: $e';
        isLoadingSolPA =
            false; // Error al cargar datos, establecer isLoading en false
      });
    } finally {
      await DatabaseHelper.closeConnection(connection);
    }
  }

  // Funcion para mostrar indicador Calidad - NC sin gestion
  Future<void> queryNoConfSinGestion() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await DatabaseHelper.executeQuery(connection,
          'SELECT COUNT(DISTINCT "NoConformidad"."id_Nc") AS cantidad_filas FROM "NoConformidad" inner JOIN "AccionCorrectiva" ON "AccionCorrectiva"."Nc" = "NoConformidad"."id_Nc" LEFT JOIN "sector" ON "NoConformidad"."Sector_id" = "sector"."id_sector" LEFT JOIN "secUser" ON "sector"."id_sector" = "secUser"."sector_id" WHERE "NoConformidad"."Cerrado" = False AND ("NoConformidad"."Sector_id" IN (SELECT "sector_id" FROM "secUser" WHERE "user_id" = $idUser)) and "NoConformidad"."OportunidadMejora"=False');
      if (result.isNotEmpty) {
        setState(() {
          indNoConfSinGestion = result.first.first.toString();
          isLoadingNCSG =
              false; // Datos cargados, establecer isLoading en false
        });
      }
    } catch (e) {
      setState(() {
        errorMessageNCSG = 'Error: $e';
        isLoadingNCSG =
            false; // Error al cargar datos, establecer isLoading en false
      });
    } finally {
      await DatabaseHelper.closeConnection(connection);
    }
  }

  // Funcion para mostrar indicador Calidad - NC por validar
  Future<void> queryNoConfPorValidar() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await DatabaseHelper.executeQuery(connection,
          'SELECT count ( distinct "AccionCorrectiva"."Descripcion") as count FROM "NoConformidad" JOIN "sector" ON "sector".id_sector = "NoConformidad"."Sector_id" JOIN "Noconformidad_Emisor" ON "Noconformidad_Emisor"."NoConformidad_id" = "NoConformidad"."id_Nc" JOIN "user" ON "user".id = "Noconformidad_Emisor".user_id LEFT JOIN "AccionCorrectiva" ON "AccionCorrectiva"."Nc" = "NoConformidad"."id_Nc" WHERE "user".id = $idUser AND ("AccionCorrectiva"."FechaValidacion" IS NULL and "AccionCorrectiva"."Nc" is not null)');
      if (result.isNotEmpty) {
        setState(() {
          indNoConfPorValidar = result.first.first.toString();
          isLoadingNCPV =
              false; // Datos cargados, establecer isLoading en false
        });
      }
    } catch (e) {
      setState(() {
        errorMessageNCPV = 'Error: $e';
        isLoadingNCPV =
            false; // Error al cargar datos, establecer 'isLoading' en false
      });
    } finally {
      await DatabaseHelper.closeConnection(connection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colores.azul)
              .copyWith(background: Colores.blanco),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
          ),
          backgroundColor: Colores.blanco,
          drawer: const MenuPage(),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.03),
                      ),
                      //Mantenimiento
                      const Text(
                        'Mantenimiento',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colores.negro,
                          shadows: [
                            Shadow(
                              color: Colores.gris, // Color del sombreado
                              offset: Offset(2,
                                  2), // Desplazamiento en píxeles del sombreado
                              blurRadius:
                                  4, // Radio de difuminado del sombreado
                            ),
                          ],
                          letterSpacing: 1.5, // Espaciado entre caracteres
                          fontStyle:
                              FontStyle.italic, // Estilo de fuente cursiva
                        ),
                      ),
                      // Espacio entre Mantenimiento y boton
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.02),
                      ),
                      // Boton Servicios por atender
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SPorAtender(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(
                            color: Colores.negro,
                            width: 2,
                          ),
                          elevation: 15,
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // Column para vertical, Row horizontal
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Servicios por atender:',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colores.negro, // Color del sombreado
                                      offset: Offset(2,
                                          2), // Desplazamiento en píxeles del sombreado
                                      blurRadius:
                                          5, // Radio de difuminado del sombreado
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.width * 0.02),
                              ),
                              isLoadingSPA
                                  ? const CircularProgressIndicator(
                                      color: Colores.amarilloClaro)
                                  : Text(
                                      indServiciosPorAtender,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colores.amarilloClaro,
                                        shadows: [
                                          Shadow(
                                            color: Colores
                                                .negro, // Color del sombreado
                                            offset: Offset(2,
                                                2), // Desplazamiento en píxeles del sombreado
                                            blurRadius:
                                                1, // Radio de difuminado del sombreado
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.02),
                      ),
                      // Boton Servicios por validar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SPorValidar(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(
                            color: Colores.negro,
                            width: 2,
                          ),
                          elevation: 15,
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // Column para vertical, Row horizontal
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Servicios por validar:',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colores.negro, // Color del sombreado
                                      offset: Offset(2,
                                          2), // Desplazamiento en píxeles del sombreado
                                      blurRadius:
                                          5, // Radio de difuminado del sombreado
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.width * 0.02),
                              ),
                              isLoadingSPV
                                  ? const CircularProgressIndicator(
                                      color: Colores.amarilloClaro)
                                  : Text(
                                      indServiciosPorValidar,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colores.amarilloClaro,
                                        shadows: [
                                          Shadow(
                                            color: Colores
                                                .negro, // Color del sombreado
                                            offset: Offset(2,
                                                2), // Desplazamiento en píxeles del sombreado
                                            blurRadius:
                                                1, // Radio de difuminado del sombreado
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.02),
                      ),
                      // Boton Servicios por validar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SolPorAtender(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(
                            color: Colores.negro,
                            width: 2,
                          ),
                          elevation: 15,
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // Column para vertical, Row horizontal
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Solicitudes por atender:',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colores.negro, // Color del sombreado
                                      offset: Offset(2,
                                          2), // Desplazamiento en píxeles del sombreado
                                      blurRadius:
                                          5, // Radio de difuminado del sombreado
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    (MediaQuery.of(context).size.width * 0.02),
                              ),
                              isLoadingSPV
                                  ? const CircularProgressIndicator(
                                      color: Colores.amarilloClaro)
                                  : Text(
                                      indSolicitudesPorAtender,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colores.amarilloClaro,
                                        shadows: [
                                          Shadow(
                                            color: Colores
                                                .negro, // Color del sombreado
                                            offset: Offset(2,
                                                2), // Desplazamiento en píxeles del sombreado
                                            blurRadius:
                                                1, // Radio de difuminado del sombreado
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Espacio entre las dos secciones
                  SizedBox(
                    height: (MediaQuery.of(context).size.width * 0.03),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Calidad
                      const Text(
                        'Calidad',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colores.negro,
                          shadows: [
                            Shadow(
                              color: Colores.gris, // Color del sombreado
                              offset: Offset(2,
                                  2), // Desplazamiento en píxeles del sombreado
                              blurRadius:
                                  4, // Radio de difuminado del sombreado
                            ),
                          ],
                          letterSpacing: 1.5, // Espaciado entre caracteres
                          fontStyle:
                              FontStyle.italic, // Estilo de fuente cursiva
                        ),
                      ),
                      // Espacio entre calidad y boton
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.02),
                      ),
                      // Boton NC sin gestion
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const NCSinGestion(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                          side: const BorderSide(
                            color: Colores.negro, // Color del borde
                            width: 2, // Grosor del borde
                          ),
                          elevation: 15,
                        ),
                        child: Column(
                          // Column para vertical, Row horizontal
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'NC sin gestión:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colores.negro, // Color del sombreado
                                    offset: Offset(2,
                                        2), // Desplazamiento en píxeles del sombreado
                                    blurRadius:
                                        5, // Radio de difuminado del sombreado
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width * 0.02),
                            ),
                            isLoadingNCSG
                                ? const CircularProgressIndicator(
                                    color: Colores.amarilloClaro)
                                : Text(
                                    indNoConfSinGestion,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colores.amarilloClaro,
                                      shadows: [
                                        Shadow(
                                          color: Colores
                                              .negro, // Color del sombreado
                                          offset: Offset(2,
                                              2), // Desplazamiento en píxeles del sombreado
                                          blurRadius:
                                              1, // Radio de difuminado del sombreado
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      // Espacio entre botones
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.02),
                      ),
                      // Boton NC por validar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds:
                                      500), // Duración de la animación
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const NCPorValidar(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colores.azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.15,
                          ),
                          side: const BorderSide(
                            color: Colores.negro, // Color del borde
                            width: 2, // Grosor del borde
                          ),
                          elevation: 15,
                        ),
                        child: Column(
                          // Column para vertical, Row horizontal
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'NC por validar:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colores.negro, // Color del sombreado
                                    offset: Offset(2,
                                        2), // Desplazamiento en píxeles del sombreado
                                    blurRadius:
                                        5, // Radio de difuminado del sombreado
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width * 0.02),
                            ),
                            isLoadingNCPV
                                ? const CircularProgressIndicator(
                                    color: Colores.amarilloClaro)
                                : Text(
                                    indNoConfPorValidar,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colores.amarilloClaro,
                                      shadows: [
                                        Shadow(
                                          color: Colores
                                              .negro, // Color del sombreado
                                          offset: Offset(2,
                                              2), // Desplazamiento en píxeles del sombreado
                                          blurRadius:
                                              1, // Radio de difuminado del sombreado
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.width * 0.03),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
