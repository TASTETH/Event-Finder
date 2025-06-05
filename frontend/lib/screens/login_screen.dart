// lib/screens/login_screen.dart
import 'package:flutter/material.dart';

// Импортируем AuthService из папки services
import 'package:event_finder/services/auth_service.dart';  // <- ваше имя пакета в pubspec.yaml

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _onLoginPressed() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите email и пароль')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final token = await AuthService.login(email: email, password: password);
      if (token != null) {
        // Вход успешен, переходим на главный экран
        Navigator.of(context).pushReplacementNamed('/home', arguments: token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный логин или пароль')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text('Войти'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: const Text('Нет учётной записи? Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

