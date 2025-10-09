import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:asistec_b/main.dart';

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
              decoration: BoxDecoration(color: Colors.blue),
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
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondS()),
                );
              },
            ),
            const ExpansionTile(
              leading: Icon(Icons.people),
              title: Text('Personal'),
              children: [
                ListTile(title: Text('Alta de personal')),
                ListTile(title: Text('Baja de personal')),
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
                  MaterialPageRoute(builder: (context) => const MyApp()),
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
              '¡Bienvenid@ ________________ Que te Gustaria consultar el dia de hoy!',
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
            ),
            const SizedBox(height: 10),
            Image.asset('assets/imagenes/Lo.jpg', width: 200, height: 150),
          ],
        ),
      ),
    );
  }
}
