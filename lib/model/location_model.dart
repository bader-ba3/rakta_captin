import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  String? locId, locName, locAdd1;
  LatLng? location;

  LocationModel({
    this.locId,
    this.locName,
    this.locAdd1,
    this.location,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    locId = json["locId"] ?? '';
    locName = json["locName"] ?? '';
    locAdd1 = json["locAdd1"] ?? '';
    location =
        LatLng(json["locationLat"] ?? 50.0, json["locationLong"] ?? 50.0);
  }

  toJson() {
    return {
      if (locId != null) "locId": locId,
      if (locName != null) "locName": locName,
      if (locAdd1 != null) "locAdd1": locAdd1,
      if (location?.latitude != null) "locationLat": location!.latitude,
      if (location?.longitude != null) "locationLong": location!.longitude,
    };
  }
}
