import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({super.key});

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();

  LocationData? _location;
  late StreamSubscription<LocationData> _locationSubscription;
  late String _error;

  @override
  void initState() {
    super.initState();
    _listenLocation();
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
          setState(() {
            _error = err.code;
          });
          _locationSubscription.cancel();
        }).listen((LocationData currentLocation) {
          setState(() {
            _error = 'null';
            _location = currentLocation;
          });
        });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 4),
      child: Container(
        padding: const EdgeInsets.all( 8.0),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(50),border: Border.all(color: Colors.black)),
        width: 100,
        height: 100,
        child: Center(
          child: Text(
            _location == null?
            "0\nKM/h"
                :'${_location!.speed != null && _location!.speed! * 3600 / 1000 > 0 ? (_location!.speed! * 3600 / 1000).toStringAsFixed(2) : 0}\nKM/h',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }
}
