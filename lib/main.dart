import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:asistec_b/Second_S.dart';

// Aqui va la ip de la maquina que tiene el SQL Server
const String apiUrl = "http://10.1.25.61:8000/login";

void main() {
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
  final TextEditingController _passwordController = TextEditingController();
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
    final password = _passwordController.text.trim();

    if (numero.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Por favor ingrese su número de empleado y contraseña.",
          ),
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
          "password": password,
        }),
      );

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        // Guardamos el ID y nombre localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userid', data['userid']);
        await prefs.setString('nombre', data['nombre']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bienvenido ${data['nombre']}"),
            backgroundColor: Colors.green,
          ),
        );

        // Navegamos a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SecondS()),
        );
      } else if (respuesta.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Credenciales inválidas."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error del servidor: ${respuesta.statusCode.toString()}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error de conexión con el servidor (${e.toString()})"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => cargando = false);
    }
  }

  // -------------------- INTERFAZ LOGIN --------------------
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Contraseña",
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: loginUsuario,
                      icon: const Icon(Icons.login),
                      label: const Text("Iniciar sesión"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 11, 234),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/imagenes/Lo.jpg',
                      width: 150,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
