import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' show cos, sqrt, asin;

import '../../controller/trip_view_model.dart';
import '../../model/location_model.dart';
import '../model/trip_model.dart';

class PolylineService {
  Future<Polyline> getdrawPolyline(List<LatLng> polylineCoordinate,Color color) async {
    try {
      List<LatLng> polylineCoordinates = polylineCoordinate;

      calcDistance(polylineCoordinates);
      return Polyline(
          polylineId: PolylineId("polyline_id ${polylineCoordinates.length}"),
          color: color,
          width: 5,
          points: polylineCoordinates,
          consumeTapEvents: true,
          onTap: () {
            Fluttertoast.showToast(
                msg: calcDistance(polylineCoordinates),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
    } on Exception catch (e) {
      Get.snackbar("Error with path", e.toString());
      throw Exception();
    }
  }

  Future<Polyline> drawPolyline(LatLng from, LatLng to, String tpId) async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyDI6RQ6KLpxiQEtyTLlUmxH4Osm4A7Zhcg",
          PointLatLng(from.latitude, from.longitude),
          PointLatLng(to.latitude, to.longitude));

      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      calcDistance(polylineCoordinates);
      List<LocationModel> location = [];
      for (var loc in polylineCoordinates) {
        location.add(LocationModel(location: loc));
      }
      Get.find<TripViewModel>()
          .editTrip(TripModel(tpId: tpId, tpPolyLine: location));
      return Polyline(
          polylineId: PolylineId("polyline_id ${result.points.length}"),
          color: const Color(0xff0f3b7f),
          points: polylineCoordinates,
          consumeTapEvents: true,
          onTap: () {
            Fluttertoast.showToast(
                msg: calcDistance(polylineCoordinates),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
    } on Exception catch (e) {
      Get.snackbar("Error with path", e.toString());

      throw Exception();
    }
  }

  String calcDistance(List<LatLng> polylineCoordinates) {
    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    return totalDistance.toStringAsFixed(2);
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
