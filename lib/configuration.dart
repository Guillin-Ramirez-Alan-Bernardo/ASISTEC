import 'package:flutter/material.dart';
import 'dart:io'; // para usar File con imágenes locales
import 'package:image_picker/image_picker.dart'; // para seleccionar imágenes
import 'package:asistec_b/Second_S.dart';
import 'package:asistec_b/main.dart';
import 'package:asistec_b/Asistencia.dart';
import 'package:asistec_b/Reportes.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  File? _image; // Imagen seleccionada
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
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
              ],
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Config()),
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
                    builder: (context) => const MyApp(showLogoutMessage: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                '¡Estás en las configuraciones!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              // Imagen de perfil con botón para cambiarla
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/imagenes/default_user.png')
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: InkWell(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(255, 0, 250, 221),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text('Usuario: Juan Pérez', style: TextStyle(fontSize: 18)),
              const Text(
                'Correo: juan.perez@itmexicali.edu.mx',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: const Text("Cambiar contraseña"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
