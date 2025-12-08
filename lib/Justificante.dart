import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Atenea/main.dart';
import 'package:Atenea/Second_S.dart';
import 'package:Atenea/Asistencia.dart';
import 'package:Atenea/Reportes.dart';

class Justifica extends StatefulWidget {
  const Justifica({super.key});

  @override
  State<Justifica> createState() => _JustiState();
}

class _JustiState extends State<Justifica> {
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

  void abrirFormulario() async {
    final url = Uri.parse(
      "https://docs.google.com/forms/d/e/1FAIpQLSeWO3XPaTNsyF5z8q99SJVznwG0S_8haN_0kijs87Jjl-GQSQ/viewform?usp=header",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "No se pudo abrir el formulario";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subir Justificante"),
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
                onPressed: abrirFormulario,
                icon: const Icon(Icons.upload),
                label: const Text('Abrir Formulario'),
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
