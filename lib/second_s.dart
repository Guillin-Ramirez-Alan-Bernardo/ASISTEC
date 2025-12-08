import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:Atenea/main.dart';
import 'package:Atenea/Asistencia.dart';
import 'package:Atenea/Reportes.dart';
import 'package:Atenea/Justificante.dart';

class SecondS extends StatefulWidget {
  const SecondS({super.key});

  @override
  State<SecondS> createState() => _SecondSState();
}

class _SecondSState extends State<SecondS> {
  String? nombreUsuario = "Usuario";

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      nombreUsuario = prefs.getString('nombre') ?? 'Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombreUsuario ?? ''),
        backgroundColor: const Color.fromARGB(255, 30, 77, 245),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 160, 178, 247),
              ),
              child: const Text(
                'Menú principal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SecondS()),
                );
              },
            ),

            ExpansionTile(
              leading: const Icon(Icons.people),
              title: const Text('Personal'),
              children: [
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text('Asistencia del Personal'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Asiste()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Reportes'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Report()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Justificante'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '¿Qué te gustaría consultar hoy?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: CalendarFormat.month,
            ),

            const SizedBox(height: 20),
            Image.asset("assets/imagenes/Lo.jpg", width: 200),
          ],
        ),
      ),
    );
  }
}
