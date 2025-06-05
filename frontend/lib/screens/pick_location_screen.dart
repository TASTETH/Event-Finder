import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LatLngResult {
  final double latitude;
  final double longitude;
  LatLngResult(this.latitude, this.longitude);
}

class PickLocationScreen extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  const PickLocationScreen(
      {Key? key, required this.initialLat, required this.initialLng})
      : super(key: key);

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng? _pickedPoint;

  @override
  void initState() {
    super.initState();
    _pickedPoint = LatLng(widget.initialLat, widget.initialLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Выберите место на карте')),
      body: FlutterMap(
        options: MapOptions(
          center: _pickedPoint,
          zoom: 12,
          onTap: (tapPosition, point) {
            setState(() {
              _pickedPoint = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.event_finder',
          ),
          if (_pickedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: _pickedPoint!,
                  child: Icon(Icons.location_on, color: Colors.pink, size: 36),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickedPoint == null
            ? null
            : () {
                Navigator.pop(
                    context,
                    LatLngResult(
                        _pickedPoint!.latitude, _pickedPoint!.longitude));
              },
        label: Text('Выбрать'),
        icon: Icon(Icons.check),
      ),
    );
  }
}
