import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/map_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EventFinderApp());
}

class EventFinderApp extends StatelessWidget {
  const EventFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/map': (context) => MapScreen(),
        '/create_event': (context) => CreateEventScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => MapScreen(),
      },
    );
  }
}
