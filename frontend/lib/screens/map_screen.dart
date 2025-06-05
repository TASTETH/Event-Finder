import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/event.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<Marker> _markers = [];
  List<Event> _localEvents = [];
  String? _selectedCategory;
  final List<String> _categories = [
    'Все',
    'Спорт',
    'Музыка',
    'Образование',
    'Вечеринка',
    'Другое'
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addEventToMap(Event event) {
    setState(() {
      _localEvents.add(event);
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    final allEvents = _localEvents;
    final filtered = _selectedCategory == null || _selectedCategory == 'Все'
        ? allEvents
        : allEvents.where((e) => e.category == _selectedCategory).toList();
    _markers = filtered.map<Marker>((event) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(event.latitude, event.longitude),
        child: GestureDetector(
          onTap: () => _showEventDetails(event),
          child: Icon(Icons.location_on, color: Colors.pink, size: 36),
        ),
      );
    }).toList();
  }

  void _loadEvents() async {
    try {
      List<Event>? fetchedEvents = await ApiService.getEvents();
      if (fetchedEvents != null && mounted) {
        setState(() {
          _localEvents = fetchedEvents;
          _updateMarkers();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки событий: ${e.toString()}')),
        );
      }
    }
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text(event.address),
                  ],
                ),
                SizedBox(height: 12),
                Text(event.briefDescription,
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 12),
                Text('Организатор: ${event.ownerUsername}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.message),
                      label: Text('Связаться'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.info),
                      label: Text('Подробнее'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('События на карте'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Создать событие',
            onPressed: () async {
              final newEvent =
                  await Navigator.pushNamed(context, '/create_event');
              if (newEvent is Event) {
                _addEventToMap(newEvent);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'Профиль',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(55.751244, 37.618423),
              zoom: 12,
              onMapReady: () {},
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.event_finder',
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск событий...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  // Реализация поиска
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories
                    .map((cat) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat ||
                                (_selectedCategory == null && cat == 'Все'),
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = cat == 'Все' ? null : cat;
                                _updateMarkers();
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
