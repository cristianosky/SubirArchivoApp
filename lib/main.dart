import 'package:app/Pages/add_item_page.dart';
import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:app/Pages/view_pdf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: const AuthenticationWrapper(),
      routes: {
        '/add': (context) => const AddItemPage(),
        '/viewpdf': (context) => const ViewPdfPage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Muestra una carga mientras se verifica el estado de autenticación.
        } else {
          final user = snapshot.data;

          if (user != null) {
            // El usuario está autenticado, muestra la página principal.
            return const Home();
          } else {
            // El usuario no está autenticado, muestra la página de inicio de sesión.
            return const LoginPage();
          }
        }
      },
    );
  }
}