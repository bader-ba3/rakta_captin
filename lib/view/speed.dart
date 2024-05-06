import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
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
  late GlobalKey<KdGaugeViewState> key ;

  @override
  void initState() {
    super.initState();
    key = GlobalKey<KdGaugeViewState>();
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
            if(_location!.speed! * 3600 / 1000>0){
              key.currentState!.updateSpeed(_location!.speed! * 3600 / 1000, animate: true,duration: Duration(milliseconds: 400));
            }
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
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(100),border: Border.all(color: Colors.black)),
        width: 120,
        height: 120,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: KdGaugeView(
              subDivisionCircleColors: Colors.transparent,
              divisionCircleColors: Colors.transparent,
              minMaxTextStyle: TextStyle(color: Colors.transparent),
              unitOfMeasurementTextStyle: TextStyle(color: Colors.transparent,fontSize: 12),
              speedTextStyle: TextStyle(fontSize:40,color: Colors.black),
              gaugeWidth: 10,
              key: key,
              minSpeed: 0,
              maxSpeed: 100,
              speed: 0,
              animate: true,
            ),
          ),
          // child: Text(
          //   _location == null?
          //   "0\nKM/h"
          //       :'${_location!.speed != null && _location!.speed! * 3600 / 1000 > 0 ? (_location!.speed! * 3600 / 1000).toStringAsFixed(2) : 0}\nKM/h',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //     fontSize: 20,
          //     letterSpacing: 4,
          //   ),
          // ),
        ),
      ),
    );
  }
}
