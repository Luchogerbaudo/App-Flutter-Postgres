// Tabla de No conformidades por validar
import 'package:flutter/material.dart';
import 'package:flutter_postgres/agregados/menu.dart';
import 'package:intl/intl.dart';
import '../agregados/colores.dart';
import '../agregados/variables.dart';
import '../conexionBaseDeDatos/database.dart';

class NCPorValidar extends StatelessWidget {
  const NCPorValidar({Key? key}) : super(key: key);

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
          title: const Text('No conformidades por validar'),
        ),
        drawer: const MenuPage(),
        body: const TNCPorValidar(),
      ),
    );
  }
}

class TNCPorValidar extends StatelessWidget {
  const TNCPorValidar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: executeQuery(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error al ejecutar la consulta: ${snapshot.error}'),
          );
        } else {
          final rows = snapshot.data!['rows'] as List<List<dynamic>>;
          final headers = snapshot.data!['headers'] as List<String>;

          if (rows.isEmpty) {
            // Mostrar el mensaje cuando no hay filas en el resultado
            return Stack(
              children: [
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No tenés no conformidades por validar.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NCPorValidar(),
                        ),
                      );
                    },
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            );
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(10.0),
                      minScale: 0.5,
                      maxScale: 2.0,
                      constrained: false,
                      child: SizedBox(
                        child: DataTable(
                          // ignore: deprecated_member_use
                          dataRowHeight: 70,
                          columns: _getColumns(headers),
                          rows: _getRows(rows),
                          dividerThickness: 2.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colores.negro,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NCPorValidar()),
                    );
                  },
                  child: const Icon(Icons.refresh),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> executeQuery() async {
    final connection = await DatabaseHelper.openConnection();
    try {
      final result = await connection.query(
          'SELECT distinct "AccionCorrectiva"."Descripcion" as "Descripcion AC", "AccionCorrectiva"."FechaImplementacion" as Fecha_Estimada, "AccionCorrectiva"."ResponsableImplementacion", "AccionCorrectiva"."FechaValidacion", "AccionCorrectiva"."Aprobado_por", "NoConformidad"."Codigo" as Codigo_NC, "NoConformidad"."Titulo" as Titulo_NC, "NoConformidad"."Fecha_Emision" as Fecha_Emision FROM "NoConformidad" JOIN "sector" ON "sector".id_sector = "NoConformidad"."Sector_id" JOIN "Noconformidad_Emisor" ON "Noconformidad_Emisor"."NoConformidad_id" = "NoConformidad"."id_Nc" JOIN "user" ON "user".id = "Noconformidad_Emisor".user_id LEFT JOIN "AccionCorrectiva" ON "AccionCorrectiva"."Nc" = "NoConformidad"."id_Nc" WHERE "user".id = $idUser AND ("AccionCorrectiva"."FechaValidacion" IS NULL and "AccionCorrectiva"."Nc" is not null)');
      final rows = result.toList(); // Obtener las filas de la tabla
      final headers =
          result.columnDescriptions.map((desc) => desc.columnName).toList();

      await connection.close();

      return {'rows': rows, 'headers': headers};
    } catch (e) {
      await connection.close();
      rethrow; // Lanzamos el error en caso de que ocurra.
    }
  }

  List<DataColumn> _getColumns(List<String> headers) {
    return headers.map((header) {
      return DataColumn(
        label: Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  List<DataRow> _getRows(List<List<dynamic>> rows) {
    return rows.map((row) {
      return DataRow(
        cells: row.map((cell) {
          if (cell is DateTime) {
            final formattedDate = DateFormat('dd/MM/yyyy').format(cell);
            return DataCell(
              Container(
                constraints: const BoxConstraints(maxWidth: 360.0),
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  formattedDate,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          return DataCell(
            Container(
              constraints: const BoxConstraints(maxWidth: 360.0),
              padding: const EdgeInsets.all(4.0),
              child: Text(
                cell.toString(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
      );
    }).toList();
  }
}
