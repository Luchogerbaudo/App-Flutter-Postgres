// Tabla de Servicios por validar
import 'package:flutter/material.dart';
import 'package:flutter_postgres/agregados/menu.dart';
import 'package:intl/intl.dart';
import '../agregados/colores.dart';
import '../agregados/variables.dart';
import '../conexionBaseDeDatos/database.dart';

class SolPorAtender extends StatelessWidget {
  const SolPorAtender({Key? key}) : super(key: key);

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
          title: const Text('Solicitudes por atender'),
        ),
        drawer: const MenuPage(),
        body: const TSolPorAtender(),
      ),
    );
  }
}

class TSolPorAtender extends StatelessWidget {
  const TSolPorAtender({Key? key}) : super(key: key);

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
                        'No tenés solicitudes por atender.',
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
                          builder: (context) => const SolPorAtender(),
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
                          builder: (context) => const SolPorAtender()),
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
          'SELECT solicitudservicio."Codigo", solicitudservicio."Descripcion", solicitudservicio."Observacion", solicitudservicio."Creado", "Tipo_pedido", "impactoAmbiental", "user".usuario, (maquina."Codigo" || \' - \' || maquina."Descripcion") AS maquina, "FechaNecesidad", solicitudservicio."Urgencia" FROM solicitudservicio LEFT JOIN maquina ON "Maquina_id" = "id_Maquina" LEFT JOIN "user" ON "Emisor_id" = "user".id WHERE solicitudservicio."Sector_id" = $sectorUser AND "Estado" = FALSE AND solicitudservicio."Eliminado" IS NULL AND "Rechazada" = FALSE order by solicitudservicio."Creado" ASC');

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
            final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(cell);
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
