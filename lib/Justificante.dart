import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:asistec_b/main.dart';
import 'package:asistec_b/Second_S.dart';
import 'package:asistec_b/configuration.dart';
import 'package:asistec_b/Asistencia.dart';
import 'package:asistec_b/Reportes.dart';

// IP de la PC donde está el FastAPI
const String apiUrl = "http://192.168.1.163:8000/Reporte_Ins";

class Justifica extends StatefulWidget {
  const Justifica({super.key});

  @override
  State<Justifica> createState() => _JustiState();
}

class _JustiState extends State<Justifica> {
  bool generando = false;
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

  void abrirFormulario() async {
    final url = Uri.parse(
      "https://docs.google.com/forms/d/e/1FAIpQLSeWO3XPaTNsyF5z8q99SJVznwG0S_8haN_0kijs87Jjl-GQSQ/viewform?usp=header",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "No se pudo abrir el formulario";
    }
  }

  // -------- INTERFAZ --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subir Justificante"),
        backgroundColor: Color.fromARGB(255, 30, 77, 245),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 234, 255),
              ),
              child: Text(
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
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Config()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyApp(showLogoutMessage: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Subir Justificante",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () => abrirFormulario(),
                icon: const Icon(Icons.logout),
                label: const Text('Subir Justificante'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 160, 178, 247),
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
