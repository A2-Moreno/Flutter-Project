import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mock_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eva',
      theme: ThemeData(
        primaryColor: const Color(0xFF4c3f6d),
        scaffoldBackgroundColor: const Color(0xFFdcd7d4),
        textTheme: GoogleFonts.robotoTextTheme().apply(
          bodyColor: const Color(0xFF4c3f6d),
          displayColor: const Color(0xFF4c3f6d),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // esto lo agregue
  final TextEditingController _userController = TextEditingController();

  // esto lo agregue
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed() {
    //Lógica de Login
    final email = _userController.text.trim();
    final password = _passwordController.text.trim();

    AppUser? foundUser;

    for (final user in mockUsers) {
      if (user.email == email && user.password == password) {
        foundUser = user;
        break;
      }
    }

    if (foundUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: foundUser!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }
  }

  // esto lo agregue
  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            //Curva decorativa superior
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: const Color(0xFF4c3f6d),
              ),
            ),

            //Formulario de login
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      children: [
                        const Text(
                          "Bienvenido",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Usuario",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _userController,
                              decoration: InputDecoration(
                                hintText: 'correo institucional',
                                filled: true,
                                fillColor: const Color(0xFFE6E2DF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Contraseña",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'contraseña',
                                filled: true,
                                fillColor: const Color(0xFFE6E2DF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: ElevatedButton(
                                onPressed: _onLoginPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4c3f6d),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Iniciar sesión",
                                  style: TextStyle(
                                    color: Color(0xFFdcd7d4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Metodo para crear una curva decorativa en la parte superior de la pantalla
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Altura donde empieza la curva
    double startY = size.height * 0.6;

    // Qué tan profunda es la curva
    double curveDepth = size.height * 0.45;

    path.lineTo(0, startY);

    path.quadraticBezierTo(
      size.width / 2,
      startY + curveDepth,
      size.width,
      startY,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// Pantalla principal
class HomeScreen extends StatelessWidget {
  final AppUser user;

  // Constructor
  const HomeScreen({super.key, required this.user});

  bool get isTeacher => user.role == UserRole.teacher;

  @override
  Widget build(BuildContext context) {
    // Lista de prueba
    final courses = [
      {'name': 'Programación Móvil', 'activities': 3},
      {'name': 'Compiladores', 'activities': 0},
      {'name': 'Proyecto Final', 'activities': 2},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFDCD7D4),

      body: SafeArea(
        child: Column(
          children: [
            // Encabezado superior morado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: const BoxDecoration(color: Color(0xFF4C3F6D)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Icono en la parte superior derecha
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C6A9F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.playlist_add_check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Hola, ${user.name}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Zona principal
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      // Curso actual que se esta pintando en la lista
                      final course = courses[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EEEB),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course['name'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF4C3F6D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${course['activities']} actividades",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4C3F6D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Abrir",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Boton para crear curso, solo profesores
                  if (isTeacher)
                    Positioned(
                      right: 18,
                      bottom: 18,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C3F6D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "+ Crear curso",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}