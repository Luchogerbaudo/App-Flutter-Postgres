// Funcion de notificacionMadre, usada una vez que se inicia sesion
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_postgres/agregados/variables.dart';
import 'package:postgres/postgres.dart';
import '../conexionBaseDeDatos/database.dart';

class NotificacionesHelper {
  static Future<void> notificacionMadre(
      PostgreSQLConnection connection) async {
    try {
      // Consulta a la base de datos para obtener servicios notificados
      final result = await DatabaseHelper.executeQuery(
          connection,
          'SELECT id, "Notificado", "Descripcion", "Servicio_Codigo" FROM "servicio" WHERE id IN (SELECT "idServicio" FROM "ServicioXUsuario" WHERE "idUser" = $idUser) AND "Notificado" = 1 order by "Notificado" ASC;');
      
      // Si hay servicios notificados, se procesan
      if (result.isNotEmpty) {
        final newNotificados = result.where((record) => record[1] == 1);

        for (var record in newNotificados) {
          String idQuery = record[0].toString();
          String descripcion = record[2].toString();
          String servicioCodigo = record[3].toString();

          // Mostrar la notificación y actualizar en la base de datos
          await _mostrarNotificacion(
              connection, idQuery, servicioCodigo, descripcion);

          await DatabaseHelper.executeQuery(connection,
              'UPDATE "servicio" SET "Notificado" = null WHERE id = $idQuery');
        }
      }
    } finally {
      // Cerrar la conexión
      connection.close();
    }
  }

  static Future<void> _mostrarNotificacion(PostgreSQLConnection connection,
      String id, String servicioCodigo, String descripcion) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Configuración de la notificación para Android
    var android = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logopnotif',
      largeIcon: DrawableResourceAndroidBitmap('logopnotif'),
    );

    var platform = NotificationDetails(android: android);

    // Mostrar la notificación
    await flutterLocalNotificationsPlugin.show(
      int.parse(id), // ID único para la notificación
      'NUEVO SERVICIO POR ATENDER',
      "$servicioCodigo - $descripcion",
      platform,
      payload: 'data',
    );

    // Actualizar en la base de datos después de mostrar la notificación
    await DatabaseHelper.executeQuery(
        connection, 'UPDATE "servicio" SET "Notificado" = null WHERE id = $id');
  }
}
