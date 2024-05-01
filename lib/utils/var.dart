import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../model/PlaceModel.dart';
import '../model/user_model.dart';
import 'data.dart';

class Const {

  static const tripStatusSearchDriver = "tripStatusSearchDriver";
  static const tripStatusWaitingDriver = "tripStatusWaitingDriver";
  static const tripStatusTripStarted = "tripStatusTripStarted";
  static const tripStatusTripPaying = "tripStatusTripPaying";


  static const String orderCollection = "Orders";
  static const String userCollection = "Users";
  static const String tripCollection = "Trips";
  static const String googleMapsApiKey =
      "AIzaSyAVncZaR4EFIhCBYlhrBeSr7FhzS78o0Bo";
  static const LatLng locationCompany = LatLng(25.79365482852805, 55.94851931755794);
  static LatLng? choosesLocation;
}

class Variables {
  static LatLng? currentLoc;

  static PlaceModel? currentLocation;

  static UserModel currentUser = users[1];
}

enum MapScreenState { pinLocation, showOrder, shipping }

enum OrderState { processing, deliveryIsInProgress, delivered, cancelled }

class LocationUtils {
  static const double earthRadius = 6371; // Radius of the Earth in kilometers

  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
