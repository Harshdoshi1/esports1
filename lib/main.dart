import 'package:flutter/material.dart';
import './screens/login.dart'; // Import the LoginScreen
import './screens/register.dart'; // Import the RegisterScreen
import './screens/home.dart'; // Import the HomeScreen
import './screens/forgotpass.dart'; // Import the ForgotPasswordScreen
import './screens/create.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/create', // Set the initial route to LoginScreen
      routes: {
        '/login': (context) => const LoginScreen(), // Route for LoginScreen
        '/register': (context) => const RegisterScreen(), // Route for RegisterScreen
        '/home': (context) => const HomePage(), // Route for HomeScreen
        '/forgotpass': (context) => const ForgotPasswordScreen(), // Route for ForgotPasswordScreen
        '/create': (context) => const CreatePage(), // Route for ForgotPasswordScreen

      },
    );
  }
}
