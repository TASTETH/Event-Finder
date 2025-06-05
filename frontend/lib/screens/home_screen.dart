// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главный экран')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Показать карту'),
              onPressed: () {
                // Переход на экран с Яндекс.Картой
                Navigator.of(context).pushNamed('/map');
              },
            ),
          ],
        ),
      ),
    );
  }
}
