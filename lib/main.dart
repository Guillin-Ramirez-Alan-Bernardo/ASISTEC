import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart'; // <-- IMPORTANTE

import 'package:asistec_b/Second_S.dart';

// Aqui va la ip de la maquina que tiene el SQL Server
const String apiUrl = "http://172.1.1.5:8000/login";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- OBLIGATORIO EN RELEASE
  await SharedPreferences.getInstance(); // <-- INICIALIZA EL CANAL NATIVO
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool showLogoutMessage;

  const MyApp({super.key, this.showLogoutMessage = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASISTEC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 11, 234),
        ),
      ),
      home: MyHomePage(title: '', showLogoutMessage: showLogoutMessage),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final bool showLogoutMessage;

  const MyHomePage({
    super.key,
    required this.title,
    this.showLogoutMessage = false,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _idController = TextEditingController();
  bool passwordVisible = false;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showLogoutMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Se ha cerrado la sesión correctamente',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
          ),
        );
      }
    });
  }

  // -------------------- LOGIN REAL --------------------
  Future<void> loginUsuario() async {
    final numero = _idController.text.trim();

    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingrese su número de empleado."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final respuesta = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "numero_empleado": int.parse(numero),
          "password": "", // si luego agregas password aquí va
        }),
      );

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userid', data['userid']);
        await prefs.setString('nombre', data['nombre']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SecondS()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error del servidor: ${respuesta.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de conexión con el servidor: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASISTEC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/tec1.png',
                      width: 300,
                      height: 150,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Número de empleado',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: loginUsuario,
                      icon: const Icon(Icons.login),
                      label: const Text("Iniciar sesión"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
