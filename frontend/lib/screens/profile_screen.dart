import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  final List<Event> upcomingEvents = [];
  final List<Event> visitedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final fetchedUser = await ApiService.getUserProfile();
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
      });
      // Пока списки оставляем пустыми, потом можно подгружать реальные данные
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user!.avatarUrl != null
                  ? NetworkImage(user!.avatarUrl!)
                  : null,
              child: user!.avatarUrl == null
                  ? Icon(Icons.person, size: 40)
                  : null,
            ),
            SizedBox(height: 8),
            Text(
              '${user!.fullName ?? ''}, ${user!.age ?? 0} лет',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              user!.city ?? '',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text('${user!.rating.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Предстоящие мероприятия',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = upcomingEvents[index];
                  return Card(
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.address),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Посещённые мероприятия',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: visitedEvents.length,
                itemBuilder: (context, index) {
                  final event = visitedEvents[index];
                  return Card(
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.address),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
