import 'package:flutter/material.dart';
import '../models/event.dart';
import 'pick_location_screen.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _briefDescController = TextEditingController();
  final _contactController = TextEditingController();
  final _detailedDescController = TextEditingController();
  bool _ageRestriction = false;

  final List<String> _categories = [
    'Спорт',
    'Музыка',
    'Образование',
    'Вечеринка',
    'Другое'
  ];
  String _selectedCategory = 'Другое';

  double? _latitude;
  double? _longitude;

  void _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickLocationScreen(
          initialLat: _latitude ?? 55.7558,
          initialLng: _longitude ?? 37.6173,
        ),
      ),
    );
    if (result is LatLngResult) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
      });
    }
  }

  void _createEvent() async {
    var title = _titleController.text;
    var address = _addressController.text;
    var briefDesc = _briefDescController.text;
    var contact = _contactController.text;
    var detailedDesc = _detailedDescController.text;
    String date = DateTime.now().toIso8601String();

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите место на карте!')),
      );
      return;
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      address: address,
      briefDescription: briefDesc,
      detailedDescription: detailedDesc,
      contactInfo: contact,
      latitude: _latitude!,
      longitude: _longitude!,
      date: date,
      ageRestriction: _ageRestriction,
      ownerId: 0,
      ownerUsername: '',
      category: _selectedCategory,
    );
    Navigator.pop(context, event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать мероприятие'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название мероприятия'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Адрес мероприятия'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _briefDescController,
              decoration: InputDecoration(labelText: 'Краткое описание'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Контакты организатора'),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _ageRestriction,
                  onChanged: (value) {
                    setState(() {
                      _ageRestriction = value!;
                    });
                  },
                ),
                Text('Возрастное ограничение'),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: _detailedDescController,
              decoration: InputDecoration(labelText: 'Подробное описание'),
              maxLines: 4,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val!;
                });
              },
              decoration: InputDecoration(labelText: 'Категория'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickLocation,
                  child: Text('Выбрать место на карте'),
                ),
                SizedBox(width: 16),
                if (_latitude != null && _longitude != null)
                  Text(
                      'Выбрано: ${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createEvent,
              child: Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}
