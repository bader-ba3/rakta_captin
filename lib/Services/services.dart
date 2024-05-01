import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';


import '../utils/var.dart';
import 'location_services.dart';

class Utils{
  double calculateDistance(LatLng lat1, LatLng lat2) {
    double dLat = LocationUtils.degreesToRadians(lat2.latitude - lat1.latitude);
    double dLon =
    LocationUtils.degreesToRadians(lat2.longitude - lat1.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(LocationUtils.degreesToRadians(lat1.latitude)) *
            cos(LocationUtils.degreesToRadians(lat2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = LocationUtils.earthRadius * c;
    return distance * 10;
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<bool> checkLocationPermission()async{
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await Location().serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await Location().requestService();
    } else {
      return false;
    }
    permissionGranted = await Location().hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Location().requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  Future<LatLng> getMyLocation() async {

    LocationData myLocation = await LocationService().getLocation();
    print(myLocation);
    return LatLng(myLocation.latitude!, myLocation.longitude!);
  }
  String timeNow() {
    var timeNow = DateTime.now();

    String formattedString = DateFormat("MMM d, y || hh:mm a").format(timeNow);
    return formattedString;
  }
}