import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:asistec_b/main.dart';
import 'package:asistec_b/Second_S.dart';
import 'package:asistec_b/Asistencia.dart';
import 'package:asistec_b/jUSTIFICANTE.dart';

// Aqui va la IP de la PC prueba
const String apiUrl = "http://172.1.1.5:8000/Reporte_Ins";

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _AsisteState();
}

class _AsisteState extends State<Report> {
  bool registrando = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userid');
    });
  }

  Future<void> RangoFecha() async {
    final DateTimeRange? rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2080),
      helpText: "Selecciona el periodo del reporte",
    );

    if (rango != null) {
      print("Inicio: ${rango.start}");
      print("Final: ${rango.end}");

      await Reportes(
        rango.start.toIso8601String(),
        rango.end.toIso8601String(),
      );
    }
  }

  Future<void> Reportes(String fechaInicio, String fechafinal) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se encontró el ID del usuario.'),
        ),
      );
      return;
    }

    setState(() => registrando = true);

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
          "fecha_final": fechafinal,
        }),
      );

      if (respuesta.statusCode == 200) {
        // 📄 Guardar PDF
        final bytes = respuesta.bodyBytes;

        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/Insidencia_$userId.pdf");
        await file.writeAsBytes(bytes);

        // Abrir archivo PDF
        OpenFile.open(file.path);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Rerporte Generado Correctamente")),
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
      setState(() => registrando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes de insidencias'),
        backgroundColor: const Color.fromARGB(255, 30, 77, 245),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 160, 178, 247),
              ),
              child: Text(
                'Menú principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondS()),
                );
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.people),
              title: Text('Personal'),
              children: [
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  title: Text('Asistencia del Personal'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Asiste()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  title: Text('Reportes'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Report()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Justifiante'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Justifica(),
                      ),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(showLogoutMessage: true),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Reporte de Insidencias',
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
                onDaySelected: (selectedDay, focusedDay) {
                  print('Seleccionaste: $selectedDay');
                },
              ),
              const SizedBox(height: 30),
              if (registrando)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => RangoFecha(),
                      icon: const Icon(Icons.file_download),
                      label: const Text('Rerporte de insidencias'),
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
                  ],
                ),
              const SizedBox(height: 30),
              Image.asset('assets/imagenes/Lo.jpg', width: 200, height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
