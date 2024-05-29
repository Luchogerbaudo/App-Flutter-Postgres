import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_postgres/agregados/menu.dart';

class Sugerencia extends StatelessWidget {
  const Sugerencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sugerencias App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sugerencias App'),
        ),
        drawer: const MenuPage(),
        body: const Center(
          child: SugerenciasWidget(),
        ),
      ),
    );
  }
}

class SugerenciasWidget extends StatefulWidget {
  const SugerenciasWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SugerenciasWidgetState createState() => _SugerenciasWidgetState();
}

class _SugerenciasWidgetState extends State<SugerenciasWidget> {
  // Variables para la sugerencia
  String subject = 'Sugerencia APP SGM';
  TextEditingController body = TextEditingController();
  String email = 'Agustin.Welschen@macoser.com.ar';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            // Campo de entrada de texto
            TextField(
              controller: body,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Escribe tu sugerencia',
              ),
            ),
            const SizedBox(height: 16.0),
            // Botón para enviar
            ElevatedButton(
              onPressed: () {
                enviarSugerencia(subject, body.text, email);
              },
              child: const Text('Enviar sugerencia'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para enviar por correo electrónico
  enviarSugerencia(String subject, String body, String recipientemail) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientemail],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }
}
