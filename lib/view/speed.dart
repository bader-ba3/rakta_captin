import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as g;
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
    /* _locationSubscription =
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
    });*/
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  Widget _calculateSpeedBetweenLocations() {

    g.Geolocator.getPositionStream(locationSettings: g.AndroidSettings(
        forceLocationManager: true,
        intervalDuration: Duration(seconds: 3),
        distanceFilter: 2,
        accuracy: g.LocationAccuracy.bestForNavigation

    )).listen((position) {
      var speedInMps =
      position.speed.toStringAsPrecision(2); // this is your speed
      print(((int.parse(speedInMps)/ 1000)* 3600 ).toString());
    });

// Check if location is null
    if (_location == null) return const Text("Hold on!");

    return Text(
      '${_location!.speed != null && _location!.speed! * 3600 / 1000 > 0 ? (_location!.speed! * 3600 / 1000).toStringAsFixed(2) : 0} KM/h',
      style: TextStyle(
        color: Colors.lightGreen[500],
        fontSize: 20,
        letterSpacing: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _calculateSpeedBetweenLocations(),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     _calculateSpeedBetweenLocations(),
        //     const SizedBox(
        //       height: 40,
        //     ),
        //     ElevatedButton(
        //         onPressed: () {
        //           _stopListen();
        //         },
        //         child: const Text("Stop"))
        //   ],
        // ),
      ),
    );
  }
}