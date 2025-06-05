// lib/screens/register_screen.dart

import 'package:flutter/material.dart';                // обязательно
import 'package:event_finder/services/auth_service.dart'; // чтобы AuthService нашёлся

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);  // <- const конструктор

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController      = TextEditingController();
  final TextEditingController _cityController     = TextEditingController();
  bool _isLoading = false;

  Future<void> _onRegisterPressed() async {
    final username = _usernameController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _fullNameController.text.trim();
    final ageText  = _ageController.text.trim();
    final city     = _cityController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните обязательные поля')),
      );
      return;
    }

    int? age;
    if (ageText.isNotEmpty) {
      age = int.tryParse(ageText);
      if (age == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Некорректный возраст')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      final success = await AuthService.register(
        username: username,
        email: email,
        password: password,
        fullName: fullName.isEmpty ? null : fullName,
        age: age,
        city: city.isEmpty ? null : city,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пользователь создан')),
        );
        Navigator.of(context).pop(); // Назад к LoginScreen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось зарегистрироваться')),
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
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Логин'),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'ФИО (необязательно)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Возраст (необязательно)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Город (необязательно)'),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onRegisterPressed,
                child: const Text('Зарегистрироваться'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
