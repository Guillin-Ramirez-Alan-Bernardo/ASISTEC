import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:Atenea/main.dart';
import 'package:Atenea/Second_S.dart';
import 'package:Atenea/Asistencia.dart';
import 'package:Atenea/Justificante.dart';

const String apiUrl = "http://172.1.1.5:8000/Reporte_Ins";

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool generando = false;
  int? userId;
  String? token;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getInt('userid');
      token = prefs.getString('token');
    });
  }

  Future<void> seleccionarRangoFecha() async {
    final DateTimeRange? rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2080),
      helpText: "Selecciona el periodo del reporte",
    );

    if (rango != null) {
      await generarReporte(
        rango.start.toIso8601String(),
        rango.end.toIso8601String(),
      );
    }
  }

  Future<void> generarReporte(String fechaInicio, String fechaFinal) async {
    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se encontró el usuario o el token.'),
        ),
      );
      return;
    }

    setState(() => generando = true);

    try {
      final respuesta = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "userid": userId,
          "fecha_inicio": fechaInicio,
          "fecha_final": fechaFinal,
        }),
      );

      if (respuesta.statusCode == 200) {
        final bytes = respuesta.bodyBytes;

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/Incidencia_$userId.pdf');
        await file.writeAsBytes(bytes);

        OpenFile.open(file.path);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Reporte generado correctamente")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("⚠️ Error: ${respuesta.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error de conexión: $e")));
    } finally {
      setState(() => generando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes de Incidencias'),
        backgroundColor: const Color.fromARGB(255, 30, 77, 245),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 160, 178, 247),
              ),
              child: Text(
                "Menú principal",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SecondS()),
                );
              },
            ),

            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text("Personal"),
              children: [
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text("Asistencia del Personal"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Asiste()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text("Reportes"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Report()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text("Justificante"),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Justifica()),
                    );
                  },
                ),
              ],
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Salir"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MyApp(prefs: prefs, showLogoutMessage: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Reporte de Incidencias",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarFormat: CalendarFormat.month,
              ),

              const SizedBox(height: 30),

              generando
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: seleccionarRangoFecha,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Generar reporte"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          160,
                          178,
                          247,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),

              const SizedBox(height: 30),

              Image.asset("assets/imagenes/Lo.jpg", width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
