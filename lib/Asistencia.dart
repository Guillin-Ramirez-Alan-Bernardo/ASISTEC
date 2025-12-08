import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Atenea/main.dart';
import 'package:Atenea/Second_S.dart';
import 'package:Atenea/Reportes.dart';
import 'package:Atenea/Justificante.dart';

const String apiUrl = "http://172.1.1.5:8000/registrar_asistencia";

class Asiste extends StatefulWidget {
  const Asiste({super.key});

  @override
  State<Asiste> createState() => _AsisteState();
}

class _AsisteState extends State<Asiste> {
  bool registrando = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getInt('userid');
    });
  }

  Future<void> registrarAsistencia(String tipo) async {
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
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userid": userId, "tipo": tipo}),
      );

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${data['mensaje']}")));
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
        title: const Text('Registro de Asistencia'),
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
                'Menú principal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SecondS()),
              ),
            ),

            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text('Personal'),
              children: [
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text('Asistencia del Personal'),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Asiste()),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Reportes'),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Report()),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Justificante'),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Justifica()),
                  ),
                ),
              ],
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir'),
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
                'Registro de Asistencia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
              ),

              const SizedBox(height: 30),

              registrando
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => registrarAsistencia("I"),
                          icon: const Icon(Icons.login),
                          label: const Text('Registrar Entrada'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () => registrarAsistencia("O"),
                          icon: const Icon(Icons.logout),
                          label: const Text('Registrar Salida'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 30),

              Image.asset('assets/imagenes/Lo.jpg', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
