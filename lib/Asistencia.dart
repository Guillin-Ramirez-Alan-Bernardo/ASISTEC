import 'package:asistec_b/configuration.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:asistec_b/main.dart';
import 'package:asistec_b/Second_S.dart';

class Asiste extends StatefulWidget {
  const Asiste({super.key});

  @override
  State<Asiste> createState() => _AsisteState();
}

class _AsisteState extends State<Asiste> {
  DateTime? fechaGu;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromARGB(255, 30, 77, 245),
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
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
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
                ListTile(title: Text('Reportes de Insidencias')),
              ],
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(showLogoutMessage: true),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.touch_app_outlined),
              title: Text('Configuracion'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Config()),
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
            const Text(
              '¡Aqui puedes registra tu asistencia el dia de hoy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Acción que se ejecuta al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondS()),
                );
              },
              child: const Text("Registra asistencia"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Acción que se ejecuta al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondS()),
                );
              },
              child: const Text("Registra Salida"),
            ),

            const SizedBox(height: 10),
            Image.asset('assets/imagenes/Lo.jpg', width: 200, height: 150),
          ],
        ),
      ),
    );
  }
}
