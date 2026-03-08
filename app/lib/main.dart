import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primaryColor: Color(0xFF4c3f6d),
        scaffoldBackgroundColor: Color(0xFFdcd7d4),
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
  void _onLoginPressed() {
    //Lógica de Login
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE6E2DF),
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE6E2DF),
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
                        ],
                      ),
                    ],
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
