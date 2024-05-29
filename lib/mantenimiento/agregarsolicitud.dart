import 'package:flutter/material.dart';
import 'package:flutter_postgres/agregados/colores.dart';
import 'package:flutter_postgres/agregados/menu.dart';
import 'package:flutter_postgres/agregados/variables.dart';
import 'package:flutter_postgres/conexionBaseDeDatos/database.dart';
import 'package:flutter_postgres/home/inicio.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ServiciosPage extends StatefulWidget {
  const ServiciosPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiciosPageState createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  DateTime? fechaSeleccionada;
  String sectorSeleccionado = "MANTENIMIENTO";
  String? urgenciaSeleccionada;
  String? fechaSeleccionadaTexto;
  String? impactoSeleccionado;
  String? eoiSeleccionado;
  String? tipoDePedidoSeleccionado;
  String? funcionaSeleccionado;
  String? maquinaSeleccionada;
  String? idSectorMaquina;
  String? sectorMaquinaSeleccionado;
  bool mostrarCampoOtro = false;
  String? otroTexto;
  String? descripcionTexto;
  String observacionTexto = '';
  double? screenWidth;
  double? fixedWidth;
  String? maquinaCodigo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colores.blanco,
        appBar: AppBar(
          title: const Text('Nueva solicitud de Servicio'),
        ),
        drawer: const MenuPage(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'AGREGAR SOLICITUD DE SERVICIOS',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontSize: 22.0,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 30.0),
                                  child: Text(
                                    '*: Campos obligatorios',
                                    style: TextStyle(
                                      color: Colores.rojo,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          // wSECTOR DESTINATARIO
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SECTOR DESTINATARIO ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder<List<String>>(
                            future: columnasDeSector(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final opciones = snapshot.data!;
                                return DropdownButton<String>(
                                  value: sectorSeleccionado,
                                  items: opciones
                                      .map((opcion) => DropdownMenuItem(
                                          value: opcion,
                                          child: Text(opcion.length > 30
                                              ? opcion.substring(0, 30)
                                              : opcion)))
                                      .toList(),
                                  onChanged: (valor) {
                                    setState(() {
                                      sectorSeleccionado = valor!;
                                    });
                                  },
                                  underline: Container(
                                    height: 2,
                                    color: Colores.gris,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          // wFECHA DE NECESIDAD
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'FECHA DE NECESIDAD ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _mostrarSelectorFecha(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fechaSeleccionada != null
                                  ? Colores.azul
                                  : Colores.gris,
                              side: const BorderSide(color: Colores.negro),
                            ),
                            child: Text(
                              fechaSeleccionada != null
                                  ? 'Fecha seleccionada: $fechaSeleccionadaTexto'
                                  : 'Seleccionar Fecha',
                              style: const TextStyle(
                                color: Colores.blanco,
                              ),
                            ),
                          ),

                          // wURGENCIA
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'URGENCIA ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: urgenciaSeleccionada,
                            items: <String>[
                              'ALTA (24 H)',
                              'MEDIA (EN LA SEMANA)',
                              'BAJA (DECIDE PLANIFICADOR)',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                urgenciaSeleccionada = newValue;
                              });
                            },
                            underline: Container(
                              height: 2,
                              color: Colores.gris,
                            ),
                          ),

                          // wIMPACTO AMBIENTAL
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿GENERA IMPACTO AMBIENTAL? ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: impactoSeleccionado,
                            items: <String>[
                              'SI',
                              'NO',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                impactoSeleccionado = newValue;
                                eoiSeleccionado = null;
                              });
                            },
                            underline: Container(
                              height: 2,
                              color: Colores.gris,
                            ),
                          ),
                          if (impactoSeleccionado == 'SI')
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TIPO DE EVENTO O INCIDENTE ',
                                      style: TextStyle(
                                        color: Colores.negro,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: Colores.rojo,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                DropdownButton<String>(
                                  value: eoiSeleccionado,
                                  items: <String>[
                                    'Derrame o filtración de sustancia peligrosa',
                                    'Incendio y/o Explosión',
                                    'Daño flora/fauna',
                                    'Fuga de gas',
                                    'Fuga de agua',
                                    'Mejoras en el proceso',
                                    'Uso eficiente de recursos',
                                    'Otro ¿Cuál?',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      eoiSeleccionado = newValue;
                                      mostrarCampoOtro =
                                          newValue == 'Otro ¿Cuál?';
                                    });
                                  },
                                  underline: Container(
                                    height: 2,
                                    color: Colores.gris,
                                  ),
                                ),
                                if (mostrarCampoOtro)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    width: fixedWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 40),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "DEFINIR 'OTRO' TIPO DE IMPACTO ",
                                              style: TextStyle(
                                                color: Colores.negro,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              '*',
                                              style: TextStyle(
                                                color: Colores.rojo,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              otroTexto = value;
                                            });
                                          },
                                          maxLines: 2,
                                          decoration: const InputDecoration(
                                            hintText: "'Otro' tipo de impacto",
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colores.grisOscuro,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colores.grisOscuro,
                                                  width: 1.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                          // wTIPO DE PEDIDO
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TIPO DE PEDIDO ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: tipoDePedidoSeleccionado,
                            onChanged: (String? newValue) {
                              setState(() {
                                tipoDePedidoSeleccionado = newValue;
                              });
                            },
                            underline: Container(
                              height: 2,
                              color: Colores.gris,
                            ),
                            items: <String>[
                              'PEDIDO DE REPARACIÓN',
                              'PEDIDO DE TRABAJO',
                              'PREVENTIVOS',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          // wSECTOR MÁQUINA
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SECTOR MÁQUINA ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder<List<String>>(
                            future: nombreSectorMaquina(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final opciones = snapshot.data!;
                                final opcionesLimitadas =
                                    opciones.map((opcion) {
                                  if (opcion.length > 30) {
                                    return opcion.substring(0, 30);
                                  }
                                  return opcion;
                                }).toList();

                                return DropdownButton<String>(
                                  value: sectorMaquinaSeleccionado,
                                  items: opcionesLimitadas
                                      .map((opcion) => DropdownMenuItem(
                                          value: opcion, child: Text(opcion)))
                                      .toList(),
                                  onChanged: (valor) {
                                    setState(() {
                                      sectorMaquinaSeleccionado = valor;
                                      idSectorMaquina = valor;
                                    });
                                  },
                                  underline: Container(
                                    height: 2,
                                    color: Colores.gris,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          Center(
                            child: sectorMaquinaSeleccionado != null
                                ? Column(
                                    children: [
                                      // wMÁQUINA
                                      const SizedBox(height: 40),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'MÁQUINA ',
                                            style: TextStyle(
                                              color: Colores.negro,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            '*',
                                            style: TextStyle(
                                              color: Colores.rojo,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FutureBuilder<List<String>>(
                                        future: nombreMaquina(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final opciones = snapshot.data!;
                                            final opcionesLimitadas =
                                                opciones.map((opcion) {
                                              if (opcion.length > 40) {
                                                return opcion.substring(0, 40);
                                              }
                                              return opcion;
                                            }).toList();

                                            return DropdownButton<String>(
                                              value: maquinaSeleccionada,
                                              items: opcionesLimitadas
                                                  .map((opcion) {
                                                final fullValue = opcion;
                                                return DropdownMenuItem(
                                                  value: fullValue,
                                                  child: Text(fullValue),
                                                );
                                              }).toList(),
                                              onChanged: (valor) {
                                                setState(() {
                                                  maquinaSeleccionada = valor;
                                                  maquinaCodigo =
                                                      valor?.split(' - ')[0];
                                                });
                                              },
                                              underline: Container(
                                                height: 2,
                                                color: Colores.gris,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text('Error');
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // wFUNCIONA
                          const SizedBox(height: 40),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿FUNCIONA? ',
                                style: TextStyle(
                                  color: Colores.negro,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colores.rojo,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: funcionaSeleccionado,
                            onChanged: (String? newValue) {
                              setState(() {
                                funcionaSeleccionado = newValue;
                              });
                            },
                            underline: Container(
                              height: 2,
                              color: Colores.gris,
                            ),
                            items: <String>[
                              'SI',
                              'NO',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          // wDESCRIPCIÓN
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            width: fixedWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DESCRIPCIÓN DEL SERVICIO ',
                                      style: TextStyle(
                                        color: Colores.negro,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: Colores.rojo,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      descripcionTexto = value;
                                    });
                                  },
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText: 'Descripción',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colores.grisOscuro,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colores.grisOscuro,
                                          width: 1.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          // wOBSERVACIÓN
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            width: fixedWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'OBSERVACIÓN',
                                      style: TextStyle(
                                        color: Colores.negro,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      observacionTexto = value;
                                    });
                                  },
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: 'Observación',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colores.grisOscuro,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colores.grisOscuro,
                                          width: 1.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // wGENERAR SOLICITUD SERVICIO
                          ElevatedButton(
                            onPressed: () {
                              enviarSoliServicio();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              alignment: Alignment.center,
                              child: const Text(
                                'GENERAR SOLICITUD DE SERVICIO',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  // SECTOR
  Future<List<String>> columnasDeSector() async {
    final connection = await DatabaseHelper.openConnection();
    final result = await DatabaseHelper.executeQuery(connection,
        'SELECT DISTINCT "NombreSector" FROM "sector" WHERE "Eliminado" IS NULL ORDER BY "NombreSector" ASC;');
    await DatabaseHelper.closeConnection(connection);

    final columnNames = result.map((row) => row[0].toString()).toList();
    return columnNames;
  }

  // SECTOR MAQUINA
  Future<List<String>> nombreSectorMaquina() async {
    final connection = await DatabaseHelper.openConnection();
    final result = await DatabaseHelper.executeQuery(connection,
        'SELECT "NombreSector", id_sector FROM public.sector WHERE "Eliminado" IS NULL AND "Codigo" IS NOT NULL AND "Activo" = \'True\' ORDER BY "NombreSector" ASC');
    await DatabaseHelper.closeConnection(connection);

    final columnNames = result.map((row) => row[0].toString()).toList();
    return columnNames;
  }

  // OBTENER id_sector
  Future<int> obtenerIdSectorPorNombre(String nombreSector) async {
    final connection = await DatabaseHelper.openConnection();
    final result = await DatabaseHelper.executeQuery(connection,
        'SELECT id_sector FROM public.sector WHERE "NombreSector" = \'$nombreSector\'');
    await DatabaseHelper.closeConnection(connection);

    if (result.isNotEmpty) {
      return result[0][0] as int;
    }
    return 0;
  }

  // MAQUINA
  Future<List<String>> nombreMaquina() async {
    final idSector = await obtenerIdSectorPorNombre(sectorMaquinaSeleccionado!);

    final connection = await DatabaseHelper.openConnection();
    final result = await DatabaseHelper.executeQuery(connection,
        'SELECT "id_Maquina", "Codigo", "Descripcion", "Sector_id" FROM public.maquina WHERE "Eliminado" IS NULL AND "Activo" = \'True\' AND "Sector_id" = $idSector;');
    await DatabaseHelper.closeConnection(connection);

    final columnNames = result.map((row) => '${row[1]} - ${row[2]}').toList();
    return columnNames;
  }

  // FECHA
  Future<void> _mostrarSelectorFecha(BuildContext context) async {
    final DateTime? seleccionado = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (seleccionado != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(seleccionado);
      setState(() {
        fechaSeleccionada = seleccionado;
        fechaSeleccionadaTexto = formattedDate;
      });
    }
  }

  //ALERT DIALOG
  void mostrarAlertaSoliEnviada() {
    QuickAlert.show(
      context: context,
      title: 'Listo',
      text: 'Solicitud enviada',
      type: QuickAlertType.success,
      autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: false,
    );
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const InicioPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void mostrarAlertaFaltanCampos() {
    QuickAlert.show(
        context: context,
        title: 'Advertencia',
        text: 'Completar campos obligatorios',
        type: QuickAlertType.warning,
        confirmBtnColor: Colores.amarillo,
        confirmBtnTextStyle: const TextStyle(color: Colores.negro),
        confirmBtnText: 'Aceptar');
  }

  void mostrarAlertaError() {
    QuickAlert.show(
        context: context,
        title: 'Error',
        text: 'No se pudo enviar la solicitud\nAvisar a sistemas',
        type: QuickAlertType.error,
        confirmBtnColor: Colores.rojo,
        confirmBtnTextStyle: const TextStyle(color: Colores.blanco),
        confirmBtnText: 'Aceptar');
  }

  //funciones para var de query

  //ENVIAR SOLICITUD
  Future<void> enviarSoliServicio() async {
    try {
      if (fechaSeleccionadaTexto != null &&
          urgenciaSeleccionada != null &&
          tipoDePedidoSeleccionado != null &&
          sectorMaquinaSeleccionado != null &&
          maquinaSeleccionada != null &&
          funcionaSeleccionado != null &&
          descripcionTexto != null &&
          impactoSeleccionado != null) {
        if (impactoSeleccionado == 'SI') {
          if (eoiSeleccionado != null) {
            if (eoiSeleccionado == 'Otro ¿Cuál?' &&
                (otroTexto == null || otroTexto!.isEmpty)) {
              mostrarAlertaFaltanCampos();
            } else {
              insertServicio();
            }
          } else {
            mostrarAlertaFaltanCampos();
          }
        } else {
          insertServicio();
        }
      } else {
        mostrarAlertaFaltanCampos();
      }
    } catch (e) {
      mostrarAlertaError();
    }
  }

  Future<void> insertServicio() async {
    final connection = await DatabaseHelper.openConnection();

    //id_sector
    final resultadoSector = await connection.query('''
  SELECT id_sector FROM public.sector WHERE "NombreSector" = '$sectorSeleccionado';''');
    int qSector = resultadoSector[0][0] as int;

    //id_Maquina
    final resultadoMaquina = await connection.query('''
    SELECT "id_Maquina" FROM public.maquina WHERE "Eliminado" IS NULL AND "Activo" = 'True' AND "Codigo" = '$maquinaCodigo';''');
    int qMaquina = resultadoMaquina[0][0] as int;

    //Descripcion
    String? qDescripcion = descripcionTexto;

    //FechaNecesidad
    DateTime qFecha = DateTime.parse(fechaSeleccionadaTexto!);

    //Urgencia
    String? qUrgencia;
    if (urgenciaSeleccionada == "ALTA(24 H)") {
      qUrgencia = "ALTA";
    } else if (urgenciaSeleccionada == "MEDIA (EN LA SEMANA)") {
      qUrgencia = "MEDIA";
    } else if (urgenciaSeleccionada == "BAJA (DECIDE PLANIFICADOR)") {
      qUrgencia = "BAJA";
    }

    //impactoAmbiental
    String? qImpacto;
    String? qTipoImpacto;
    String? qOtroTipoImpacto;
    if (impactoSeleccionado == "SI") {
      qImpacto = "SI";
      //tipoImpactoAmbiental
      if (eoiSeleccionado ==
          "Derrame o filtración de sustancia peligrosa / residuo peligroso") {
        qTipoImpacto = '1';
      } else if (eoiSeleccionado == "Incendio y/o Explosión") {
        qTipoImpacto = '2';
      } else if (eoiSeleccionado == "Daño flora/fauna") {
        qTipoImpacto = '3';
      } else if (eoiSeleccionado == "Fuga de gas") {
        qTipoImpacto = '4';
      } else if (eoiSeleccionado == "Fuga de agua") {
        qTipoImpacto = '5';
      } else if (eoiSeleccionado == "Mejoras en el proceso") {
        qTipoImpacto = '7';
      } else if (eoiSeleccionado == "Uso eficiente de recursos") {
        qTipoImpacto = '8';
      } else if (eoiSeleccionado == "Otro ¿Cuál?") {
        qTipoImpacto = '6';
        //otroTipoImpactoAmbiental
        qOtroTipoImpacto = otroTexto;
      }
    } else if (impactoSeleccionado == "NO") {
      qImpacto = "NO";
    }

    //Observacion
    String? qObservacion = observacionTexto;

    //Tipo_pedido
    String? qTipoPedido = tipoDePedidoSeleccionado;

    //Funciona
    bool? qFunciona;
    if (funcionaSeleccionado == "SI") {
      qFunciona = true;
    } else if (funcionaSeleccionado == "NO") {
      qFunciona = false;
    }

    //Codigo
    var maxIdResultado =
        await connection.query('SELECT MAX(id) FROM solicitudservicio');
    int maxId = maxIdResultado[0][0] as int;
    int qId = maxId + 1;
    int anoActual = DateTime.now().year;
    int idCodigo = qId + 1;
    String qCodigo = "SS$anoActual.$idCodigo";

    //Creado
    DateTime fechaActual = DateTime.now();
    String qCreado = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(fechaActual);

    //CONSULTA FINAL. CHAN CHAN CHAAAN
    try {
      await connection.query('''
        INSERT INTO solicitudservicio (id, "Sector_id", "Maquina_id", "Emisor_id", "Imagen", "Descripcion", "FechaNecesidad", "Urgencia", "impactoAmbiental", "tipoImpactoAmbiental", "otroTipoImpactoAmbiental", "Observacion", "Estado", "Tipo_pedido", "Funciona", "Codigo", "Creado", "Creado_por", "Rechazada")
        VALUES ($qId, $qSector, $qMaquina, $idUser, NULL, '$qDescripcion', '$qFecha', '$qUrgencia', '$qImpacto', '$qTipoImpacto', '$qOtroTipoImpacto', '$qObservacion', false, '$qTipoPedido', $qFunciona, '$qCodigo', '$qCreado', $idUser, false);
      ''');
      mostrarAlertaSoliEnviada();
    } catch (e) {
      await connection.close();
      mostrarAlertaError();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_postgres/agregados/colores.dart';
// import 'package:flutter_postgres/agregados/menu.dart';
// import 'package:flutter_postgres/agregados/variables.dart';
// import 'package:flutter_postgres/conexionBaseDeDatos/database.dart';
// import 'package:flutter_postgres/home/inicio.dart';
// import 'package:intl/intl.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// class ServiciosPage extends StatefulWidget {
//   const ServiciosPage({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ServiciosPageState createState() => _ServiciosPageState();
// }

// class _ServiciosPageState extends State<ServiciosPage> {
//   DateTime? fechaSeleccionada;
//   String? sectorSeleccionado;
//   String? urgenciaSeleccionada;
//   String? fechaSeleccionadaTexto;
//   String? impactoSeleccionado;
//   String? eoiSeleccionado;
//   String? otroTexto;
//   String? tipoDePedidoSeleccionado;
//   String? funcionaSeleccionado;
//   String? maquinaSeleccionada;
//   String? idSectorMaquina;
//   bool mostrarCampoOtro = false;
//   String? descripcionTexto;
//   String observacionTexto = '';
//   double? screenWidth;
//   double? fixedWidth;
//   String? maquinaCodigo;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colores.blanco,
//         appBar: AppBar(
//           title: const Text('Nueva solicitud de Servicio'),
//         ),
//         drawer: const MenuPage(),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),
//                           const Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'AGREGAR SOLICITUD DE SERVICIOS',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontSize: 22.0,
//                                 ),
//                               ),
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(left: 30.0),
//                                   child: Text(
//                                     '*: Campos obligatorios',
//                                     style: TextStyle(
//                                       color: Colores.rojo,
//                                       fontSize: 14.0,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),

//                           // wSECTOR DESTINATARIO
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'SECTOR DESTINATARIO ',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           FutureBuilder<List<String>>(
//                             future: columnasDeSector(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 final opciones = snapshot.data!;
//                                 return DropdownButton<String>(
//                                   value: sectorSeleccionado,
//                                   items: opciones
//                                       .map((opcion) => DropdownMenuItem(
//                                           value: opcion,
//                                           child: Text(opcion.length > 30
//                                               ? opcion.substring(0, 30)
//                                               : opcion)))
//                                       .toList(),
//                                   onChanged: (valor) {
//                                     setState(() {
//                                       sectorSeleccionado = valor;
//                                     });
//                                   },
//                                   underline: Container(
//                                     height: 2,
//                                     color: Colores.gris,
//                                   ),
//                                 );
//                               } else if (snapshot.hasError) {
//                                 return const Text('Error');
//                               } else {
//                                 return const SizedBox.shrink();
//                               }
//                             },
//                           ),

//                           // wFECHA DE NECESIDAD
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'FECHA DE NECESIDAD ',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           ElevatedButton(
//                             onPressed: () => _mostrarSelectorFecha(context),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: fechaSeleccionada != null
//                                   ? Colores.azul
//                                   : Colores.gris,
//                               side: const BorderSide(color: Colores.negro),
//                             ),
//                             child: Text(
//                               fechaSeleccionada != null
//                                   ? 'Fecha seleccionada: $fechaSeleccionadaTexto'
//                                   : 'Seleccionar Fecha',
//                               style: const TextStyle(
//                                 color: Colores.blanco,
//                               ),
//                             ),
//                           ),

//                           // wURGENCIA
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'URGENCIA ',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           DropdownButton<String>(
//                             value: urgenciaSeleccionada,
//                             items: <String>[
//                               'ALTA (24 H)',
//                               'MEDIA (EN LA SEMANA)',
//                               'BAJA (DECIDE PLANIFICADOR)',
//                             ].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 urgenciaSeleccionada = newValue;
//                               });
//                             },
//                             underline: Container(
//                               height: 2,
//                               color: Colores.gris,
//                             ),
//                           ),

//                           // wIMPACTO AMBIENTAL
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '¿GENERA IMPACTO AMBIENTAL?',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           DropdownButton<String>(
//                             value: impactoSeleccionado,
//                             items: <String>[
//                               'SI',
//                               'NO',
//                             ].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 impactoSeleccionado = newValue;

//                                 if (impactoSeleccionado == 'NO') {
//                                   eoiSeleccionado = null;
//                                   mostrarCampoOtro = false;
//                                   otroTexto = null;
//                                 }
//                               });
//                             },
//                             underline: Container(
//                               height: 2,
//                               color: Colores.gris,
//                             ),
//                           ),
//                           if (impactoSeleccionado == 'SI')
//                             Column(
//                               children: [
//                                 const SizedBox(height: 40),
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'TIPO DE EVENTO O INCIDENTE ',
//                                       style: TextStyle(
//                                         color: Colores.negro,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16.0,
//                                       ),
//                                     ),
//                                     Text(
//                                       '*',
//                                       style: TextStyle(
//                                         color: Colores.rojo,
//                                         fontSize: 16.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 DropdownButton<String>(
//                                   value: eoiSeleccionado,
//                                   items: <String>[
//                                     'Derrame o filtración de sustancia peligrosa',
//                                     'Incendio y/o Explosión',
//                                     'Daño flora/fauna',
//                                     'Fuga de gas',
//                                     'Fuga de agua',
//                                     'Mejoras en el proceso',
//                                     'Uso eficiente de recursos',
//                                     'Otro ¿Cuál?',
//                                   ].map((String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value),
//                                     );
//                                   }).toList(),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       eoiSeleccionado = newValue;
//                                       mostrarCampoOtro =
//                                           newValue == 'Otro ¿Cuál?';
//                                     });
//                                   },
//                                   underline: Container(
//                                     height: 2,
//                                     color: Colores.gris,
//                                   ),
//                                 ),
//                                 if (mostrarCampoOtro)
//                                   Container(
//                                     padding: const EdgeInsets.only(
//                                         left: 20, right: 20),
//                                     width: fixedWidth,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         const SizedBox(height: 40),
//                                         const Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "DEFINIR 'OTRO' TIPO DE IMPACTO ",
//                                               style: TextStyle(
//                                                 color: Colores.negro,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16.0,
//                                               ),
//                                             ),
//                                             Text(
//                                               '*',
//                                               style: TextStyle(
//                                                 color: Colores.rojo,
//                                                 fontSize: 16.0,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 10),
//                                         TextField(
//                                           onChanged: (value) {
//                                             setState(() {
//                                               otroTexto = value;
//                                             });
//                                           },
//                                           maxLines: 2,
//                                           decoration: const InputDecoration(
//                                             hintText: "'Otro' tipo de impacto",
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colores.grisOscuro,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colores.grisOscuro,
//                                                   width: 1.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),

//                           // wTIPO DE PEDIDO
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'TIPO DE PEDIDO ',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           DropdownButton<String>(
//                             value: tipoDePedidoSeleccionado,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 tipoDePedidoSeleccionado = newValue;
//                               });
//                             },
//                             underline: Container(
//                               height: 2,
//                               color: Colores.gris,
//                             ),
//                             items: <String>[
//                               'PEDIDO DE REPARACIÓN',
//                               'PEDIDO DE TRABAJO',
//                               'PREVENTIVOS',
//                             ].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),

//                           // wMÁQUINA
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'MÁQUINA',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           FutureBuilder<List<String>>(
//                             future: nombreMaquina(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 final opciones = snapshot.data!;
//                                 final opcionesLimitadas =
//                                     opciones.map((opcion) {
//                                   if (opcion.length > 40) {
//                                     return opcion.substring(0, 40);
//                                   }
//                                   return opcion;
//                                 }).toList();

//                                 return DropdownButton<String>(
//                                   value: maquinaSeleccionada,
//                                   items: opcionesLimitadas.map((opcion) {
//                                     final fullValue = opcion;
//                                     return DropdownMenuItem(
//                                       value: fullValue,
//                                       child: Text(
//                                         fullValue,
//                                         style: const TextStyle(
//                                           fontSize: 16.0,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                   onChanged: (valor) {
//                                     setState(() {
//                                       maquinaSeleccionada = valor;
//                                       final partes = valor?.split('\n') ?? [];
//                                       maquinaCodigo = partes[1].split(' - ')[0];
//                                     });
//                                   },
//                                   underline: Container(
//                                     height: 2,
//                                     color: Colores.gris,
//                                   ),
//                                 );
//                               } else if (snapshot.hasError) {
//                                 return const Text('Error');
//                               } else {
//                                 return const SizedBox.shrink();
//                               }
//                             },
//                           ),

//                           // wFUNCIONA
//                           const SizedBox(height: 40),
//                           const Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '¿FUNCIONA? ',
//                                 style: TextStyle(
//                                   color: Colores.negro,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colores.rojo,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           DropdownButton<String>(
//                             value: funcionaSeleccionado,
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 funcionaSeleccionado = newValue;
//                               });
//                             },
//                             underline: Container(
//                               height: 2,
//                               color: Colores.gris,
//                             ),
//                             items: <String>[
//                               'SI',
//                               'NO',
//                             ].map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),

//                           // wDESCRIPCIÓN
//                           Container(
//                             padding: const EdgeInsets.only(left: 20, right: 20),
//                             width: fixedWidth,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const SizedBox(height: 40),
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'DESCRIPCIÓN DEL SERVICIO ',
//                                       style: TextStyle(
//                                         color: Colores.negro,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16.0,
//                                       ),
//                                     ),
//                                     Text(
//                                       '*',
//                                       style: TextStyle(
//                                         color: Colores.rojo,
//                                         fontSize: 16.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 TextField(
//                                   onChanged: (value) {
//                                     setState(() {
//                                       descripcionTexto = value;
//                                     });
//                                   },
//                                   maxLines: 4,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Descripción',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colores.grisOscuro,
//                                           width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colores.grisOscuro,
//                                           width: 1.0),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),

//                           // wOBSERVACIÓN
//                           Container(
//                             padding: const EdgeInsets.only(left: 20, right: 20),
//                             width: fixedWidth,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const SizedBox(height: 40),
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'OBSERVACIÓN',
//                                       style: TextStyle(
//                                         color: Colores.negro,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 TextField(
//                                   onChanged: (value) {
//                                     setState(() {
//                                       observacionTexto = value;
//                                     });
//                                   },
//                                   maxLines: 3,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Observación',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colores.grisOscuro,
//                                           width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: Colores.grisOscuro,
//                                           width: 1.0),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 40),

//                           // wGENERAR SOLICITUD SERVICIO
//                           ElevatedButton(
//                             onPressed: () {
//                               enviarSoliServicio();
//                             },
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.8,
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 'GENERAR SOLICITUD DE SERVICIO',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   // SECTOR
//   Future<List<String>> columnasDeSector() async {
//     final connection = await DatabaseHelper.openConnection();
//     final result = await DatabaseHelper.executeQuery(connection,
//         'SELECT DISTINCT "NombreSector" FROM "sector" WHERE "Eliminado" IS NULL ORDER BY "NombreSector" ASC;');
//     await DatabaseHelper.closeConnection(connection);

//     final columnNames = result.map((row) => row[0].toString()).toList();
//     return columnNames;
//   }

//   // MAQUINA
//   Future<List<String>> nombreMaquina() async {
//     final connection = await DatabaseHelper.openConnection();
//     final result = await DatabaseHelper.executeQuery(connection, '''
//       SELECT m."id_Maquina", m."Codigo", m."Descripcion", s."NombreSector"
//       FROM public.maquina m
//       JOIN public.sector s ON m."Sector_id" = s.id_sector
//       WHERE m."Eliminado" IS NULL AND m."Activo" = 'True'
//       ORDER BY s."NombreSector" ASC, m."Descripcion" ASC;
//     ''');
//     await DatabaseHelper.closeConnection(connection);

//     final columnNames =
//         result.map((row) => '${row[3]}\n${row[1]} - ${row[2]}').toList();
//     return columnNames;
//   }

//   // FECHA
//   Future<void> _mostrarSelectorFecha(BuildContext context) async {
//     final DateTime? seleccionado = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (seleccionado != null) {
//       final formattedDate = DateFormat('yyyy-MM-dd').format(seleccionado);
//       setState(() {
//         fechaSeleccionada = seleccionado;
//         fechaSeleccionadaTexto = formattedDate;
//       });
//     }
//   }

//   //ALERT DIALOG
//   void mostrarAlertaSoliEnviada() {
//     QuickAlert.show(
//       context: context,
//       title: 'Listo',
//       text: 'Solicitud enviada',
//       type: QuickAlertType.success,
//       autoCloseDuration: const Duration(seconds: 2),
//       showConfirmBtn: false,
//     );
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         transitionDuration: const Duration(milliseconds: 500),
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             const InicioPage(),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//       ),
//     );
//   }

//   void mostrarAlertaFaltanCampos() {
//     QuickAlert.show(
//         context: context,
//         title: 'Advertencia',
//         text: 'Completar campos obligatorios',
//         type: QuickAlertType.warning,
//         confirmBtnColor: Colores.amarillo,
//         confirmBtnTextStyle: const TextStyle(color: Colores.negro),
//         confirmBtnText: 'Aceptar');
//   }

//   void mostrarAlertaError() {
//     QuickAlert.show(
//         context: context,
//         title: 'Error',
//         text: 'No se pudo enviar la solicitud\nAvisar a sistemas',
//         type: QuickAlertType.error,
//         confirmBtnColor: Colores.rojo,
//         confirmBtnTextStyle: const TextStyle(color: Colores.blanco),
//         confirmBtnText: 'Aceptar');
//   }

//   //funciones para var de query

//   //ENVIAR SOLICITUD
//   Future<void> enviarSoliServicio() async {
//     try {
//       if (sectorSeleccionado != null &&
//           fechaSeleccionadaTexto != null &&
//           urgenciaSeleccionada != null &&
//           tipoDePedidoSeleccionado != null &&
//           maquinaSeleccionada != null &&
//           funcionaSeleccionado != null &&
//           descripcionTexto != null &&
//           impactoSeleccionado != null) {
//         if (impactoSeleccionado == 'SI') {
//           if (eoiSeleccionado != null) {
//             if (eoiSeleccionado == 'Otro ¿Cuál?' &&
//                 (otroTexto == null || otroTexto!.isEmpty)) {
//               mostrarAlertaFaltanCampos();
//             } else {
//               insertServicio();
//             }
//           } else {
//             mostrarAlertaFaltanCampos();
//           }
//         } else {
//           insertServicio();
//         }
//       } else {
//         mostrarAlertaFaltanCampos();
//       }
//     } catch (e) {
//       mostrarAlertaError();
//     }
//   }

//   Future<void> insertServicio() async {
//     final connection = await DatabaseHelper.openConnection();

//     //id_sector
//     final resultadoSector = await connection.query('''
//   SELECT id_sector FROM public.sector WHERE "NombreSector" = '$sectorSeleccionado';''');
//     int qSector = resultadoSector[0][0] as int;

//     //id_Maquina
//     final resultadoMaquina = await connection.query('''
//     SELECT "id_Maquina" FROM public.maquina WHERE "Eliminado" IS NULL AND "Activo" = 'True' AND "Codigo" = '$maquinaCodigo';''');
//     int qMaquina = resultadoMaquina[0][0] as int;

//     //Descripcion
//     String? qDescripcion = descripcionTexto;

//     //FechaNecesidad
//     DateTime qFecha = DateTime.parse(fechaSeleccionadaTexto!);

//     //Urgencia
//     String? qUrgencia;
//     if (urgenciaSeleccionada == "ALTA (24 H)") {
//       qUrgencia = "ALTA";
//     } else if (urgenciaSeleccionada == "MEDIA (EN LA SEMANA)") {
//       qUrgencia = "MEDIA";
//     } else if (urgenciaSeleccionada == "BAJA (DECIDE PLANIFICADOR)") {
//       qUrgencia = "BAJA";
//     }

//     //impactoAmbiental
//     String? qImpacto;
//     String? qTipoImpacto;
//     String? qOtroTipoImpacto;
//     if (impactoSeleccionado == "SI") {
//       qImpacto = "SI";
//       //tipoImpactoAmbiental
//       if (eoiSeleccionado ==
//           "Derrame o filtración de sustancia peligrosa / residuo peligroso") {
//         qTipoImpacto = '1';
//       } else if (eoiSeleccionado == "Incendio y/o Explosión") {
//         qTipoImpacto = '2';
//       } else if (eoiSeleccionado == "Daño flora/fauna") {
//         qTipoImpacto = '3';
//       } else if (eoiSeleccionado == "Fuga de gas") {
//         qTipoImpacto = '4';
//       } else if (eoiSeleccionado == "Fuga de agua") {
//         qTipoImpacto = '5';
//       } else if (eoiSeleccionado == "Mejoras en el proceso") {
//         qTipoImpacto = '7';
//       } else if (eoiSeleccionado == "Uso eficiente de recursos") {
//         qTipoImpacto = '8';
//       } else if (eoiSeleccionado == "Otro ¿Cuál?") {
//         qTipoImpacto = '6';
//         //otroTipoImpactoAmbiental
//         qOtroTipoImpacto = otroTexto;
//       }
//     } else if (impactoSeleccionado == "NO") {
//       qImpacto = "NO";
//     }

//     //Observacion
//     String? qObservacion = observacionTexto;

//     //Tipo_pedido
//     String? qTipoPedido = tipoDePedidoSeleccionado;

//     //Funciona
//     bool? qFunciona;
//     if (funcionaSeleccionado == "SI") {
//       qFunciona = true;
//     } else if (funcionaSeleccionado == "NO") {
//       qFunciona = false;
//     }

//     //Codigo
//     var maxIdResultado =
//         await connection.query('SELECT MAX(id) FROM solicitudservicio');
//     int maxId = maxIdResultado[0][0] as int;
//     int qId = maxId + 1;
//     int anoActual = DateTime.now().year;
//     int idCodigo = qId + 1;
//     String qCodigo = "SS$anoActual.$idCodigo";

//     //Creado
//     DateTime fechaActual = DateTime.now();
//     String qCreado = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(fechaActual);

//     //CONSULTA FINAL. CHAN CHAN CHAAAN
//     try {
//       await connection.query('''
//         INSERT INTO solicitudservicio (id, "Sector_id", "Maquina_id", "Emisor_id", "Imagen", "Descripcion", "FechaNecesidad", "Urgencia", "impactoAmbiental", "tipoImpactoAmbiental", "otroTipoImpactoAmbiental", "Observacion", "Estado", "Tipo_pedido", "Funciona", "Codigo", "Creado", "Creado_por", "Rechazada")
//         VALUES ($qId, $qSector, $qMaquina, $idUser, NULL, '$qDescripcion', '$qFecha', '$qUrgencia', '$qImpacto', $qTipoImpacto, ${qOtroTipoImpacto != null ? "'$qOtroTipoImpacto'" : 'NULL'},  '$qObservacion', false, '$qTipoPedido', $qFunciona, '$qCodigo', '$qCreado', $idUser, false);
//       ''');
//       mostrarAlertaSoliEnviada();
//     } catch (e) {
//       await connection.close();
//       mostrarAlertaError();
//     }
//   }
// }
