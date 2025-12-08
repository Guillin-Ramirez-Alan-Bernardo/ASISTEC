import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Atenea/Second_S.dart';

// IP del servidor FastAPI
const String apiUrl = "http://172.1.1.5:8000/login";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SharedPreferences ANTES de construir la app
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool showLogoutMessage;

  const MyApp({super.key, required this.prefs, this.showLogoutMessage = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASISTEC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 11, 234),
        ),
      ),
      home: MyHomePage(
        title: '',
        prefs: prefs,
        showLogoutMessage: showLogoutMessage,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final SharedPreferences prefs;
  final bool showLogoutMessage;

  const MyHomePage({
    super.key,
    required this.title,
    required this.prefs,
    this.showLogoutMessage = false,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _idController = TextEditingController();
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
        body: jsonEncode({"numero_empleado": int.parse(numero)}),
      );

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);

        widget.prefs.setInt('userid', data['userid']);
        widget.prefs.setString('nombre', data['nombre']);
        widget.prefs.setString('token', data['token']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecondS()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error del servidor: ${respuesta.statusCode}"),
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

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: loginUsuario,
                      icon: const Icon(Icons.login),
                      label: const Text("Iniciar sesión"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 160, 178, 247),
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
