import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:asistec_b/main.dart';
import 'package:asistec_b/Asistencia.dart';
import 'package:asistec_b/Reportes.dart';
import 'package:asistec_b/Justificante.dart';

class SecondS extends StatelessWidget {
  const SecondS({super.key});

  @override
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
                color: const Color.fromARGB(255, 160, 178, 247),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido que te gustaria consultar el dia de hoy?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2025, 10, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                print('Seleccionaste: $selectedDay');
              },
              selectedDayPredicate: (day) => false,
              onFormatChanged: (format) {},
            ),
            const SizedBox(height: 10),
            Image.asset('assets/imagenes/Lo.jpg', width: 200, height: 150),
          ],
        ),
      ),
    );
  }
}
