// Vista al iniciar la app, pagina de Login
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_postgres/home/inicio.dart';
import 'package:flutter_postgres/agregados/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'agregados/colores.dart';
import 'conexionBaseDeDatos/database.dart';
import 'package:package_info/package_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colores.azul)
            .copyWith(background: Colores.blanco),
      ),
      home: const PagLogin(),
    );
  }
}

class PagLogin extends StatefulWidget {
  const PagLogin({Key? key}) : super(key: key);

  @override
  State<PagLogin> createState() => _PagLoginState();
}

class _PagLoginState extends State<PagLogin> {
  String loginStatus = '';
  String recuerdeBd = '';
  late SharedPreferences sharedPreferences;
  final TextEditingController usernameController = TextEditingController();
  String lastUsername = '';

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    verVersion();
  }

  // Inicializar SharedPreferences para guardar el último nombre de usuario
  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    lastUsername = sharedPreferences.getString('lastUsername') ?? '';
    setState(() {
      usernameController.text = lastUsername;
    });
  }

  // Obtener información de la versión de la aplicación
  Future<void> verVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  // Validar si hay una versión nueva de la aplicación
  Future<void> validarVersion() async {
    // Cuando se actualice en el play store, cambiar la version en la BD:
    // UPDATE aviso SET version = 'X.X.X' WHERE codigo = 'VERS_APP';

    final connection = await DatabaseHelper.openConnection();

    final List<List<dynamic>> results = await connection.query(
      "SELECT version FROM aviso WHERE codigo = 'VERS_APP'",
    );

    if (results.isNotEmpty) {
      final String versionActual = results.first[0].toString();

      if (appVersion != versionActual) {
        // Mostrar diálogo de actualización
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Actualizar app'),
              content: Text('Nueva versión disponible: $versionActual.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar.'),
                ),
                TextButton(
                  onPressed: () async {
                    const String url =
                        'https://play.google.com/store/apps/details?id=com.macosersgm.flutter';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: const Text('Actualizar.'),
                ),
              ],
            );
          },
        );
      }
    }

    await connection.close();
  }

  // Parámetros y extensión para la conexión a PostgreSQL remota
  Future<void> login() async {
    try {
      final connection = await DatabaseHelper.openConnection();

      try {
        final String username = usernameController.text;

        final List<List<dynamic>> results = await connection.query(
          "SELECT * FROM \"user\" WHERE usuario = @username",
          substitutionValues: {'username': username},
        );

        if (results.isNotEmpty) {
          // Guardar la última sesión iniciada
          sharedPreferences.setString('lastUsername', username);
          idUser = results.first[0].toString();
          nombreUser = results.first[1].toString();
          apellidoUser = results.first[2].toString();
          emailUser = results.first[3].toString();
          sectorUser = results.first[15].toString();

          // Limpiar estados
          setState(() {
            loginStatus = '';
            recuerdeBd = '';
          });

          // Validar si hay una versión nueva de la aplicación
          validarVersion();

          // Navegar a la página de inicio
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const InicioPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        } else {
          setState(() {
            loginStatus = 'Invalid username';
            recuerdeBd = '';
          });
        }

        await connection.close();
      } catch (databaseError) {
        // Error en la base de datos
        setState(() {
          loginStatus = 'Error executing the query: $databaseError';
          recuerdeBd = '';
        });
      }
    } catch (connectionError) {
      // Error al conectar con la base de datos
      setState(() {
        loginStatus = 'Error connecting to the database: $connectionError';
        recuerdeBd = 'Remember to be connected to MACOSER_TELEFONIA';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de Macoser
            Image.asset('assets/logo.png'),

            const SizedBox(height: 40),

            // Ingresar usuario
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 22,
                  color: Colores.grisOscuro,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter a valid username'),
                  ),
                ),
              ],
            ),

            // Botón para iniciar sesión
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                  color: Colores.negro, // Color del borde
                  width: 1, // Grosor del borde
                ),
                elevation: 15,
              ),
              child: const Text('Log in'),
            ),

            // Mostrar si no se inició sesión
            const SizedBox(height: 16.0),
            Column(children: [
              // Estado de inicio de sesión si no se logró
              Text(
                loginStatus,
                style: const TextStyle(
                  color: Colores.rojo,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              Text(
                recuerdeBd,
                style: const TextStyle(
                  color: Colores.negro,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ]),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            'Versión: $appVersion',
            style: const TextStyle(fontSize: 12.0, color: Colores.grisOscuro),
          ),
        ),
      ),
    );
  }
}
