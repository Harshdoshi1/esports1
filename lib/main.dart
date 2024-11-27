import 'package:flutter/material.dart';
import './screens/login.dart'; // Import the LoginScreen
import './screens/register.dart'; // Import the RegisterScreen
import './screens/home.dart'; // Import the HomeScreen
import './screens/forgotpass.dart'; // Import the ForgotPasswordScreen
import './screens/create.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'firebase_options.dart'; // Import Firebase options for proper configuration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Ensure Firebase is initialized with the correct platform options
    );
    print("Firebase Initialized Successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

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
      initialRoute: '/home', // Set the initial route to HomeScreen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) {
          final List<Map<String, String>> videos = []; // Initialize videos list here or fetch from Firebase
          return HomePage(videos: videos);
        },
        '/forgotpass': (context) => const ForgotPasswordScreen(),
        '/create': (context) => const CreatePage(),
      },
    );
  }
}
