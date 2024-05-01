

import '../Services/services.dart';
import '../../model/location_model.dart';

class TripModel {
  String? tpId, tpUser, tpRider, tpCost, tpDate;

  LocationModel? tpSrc, tpDest;
  TripStatus? tpStatus;
  List<LocationModel>? tpLocation = [];
  List<LocationModel>? tpPolyLine = [];

  TripModel({
    this.tpId,
    this.tpUser,
    this.tpRider,
    this.tpSrc,
    this.tpDest,
    this.tpCost,
    this.tpStatus,
    this.tpLocation,
    this.tpPolyLine,
    this.tpDate,
  });

  TripModel.fromJson(Map<String, dynamic> map) {
    tpId = map["tpId"] ?? '';
    tpUser = map["tpUser"] ?? '';
    tpRider = map["tpRider"] ?? '';
    tpSrc = LocationModel.fromJson(map["tpSrc"] ?? {});
    tpDest = LocationModel.fromJson(map["tpDest"] ?? {});
    tpCost = map["tpCost"] ?? "0";
    tpStatus = tripStatusFromString(map["tpStatus"] ?? "TripStatus.canceled");
    tpDate = map["tpDate"];
    for (var loc in map["tpLocation"] ?? {}) {
      tpLocation?.add(LocationModel.fromJson(loc));
    }
    for (var loc in map["tpPolyLine"] ?? {}) {
      tpPolyLine?.add(LocationModel.fromJson(loc));
    }
  }

  toJson() {
    return {
      if (tpId != null) "tpId": tpId,
      if (tpUser != null) "tpUser": tpUser,
      "tpDate": Utils().timeNow(),
      if (tpRider != null) "tpRider": tpRider,
      if (tpSrc != null) "tpSrc": tpSrc?.toJson(),
      if (tpDest != null) "tpDest": tpDest?.toJson(),
      if (tpCost != null) "tpCost": tpCost,
      if (tpStatus != null) "tpStatus": tpStatus.toString(),
      if (tpLocation != null)
        "tpLocation": tpLocation!.map((location) => location.toJson()).toList(),
      if (tpPolyLine != null)
        "tpPolyLine": tpPolyLine?.map((location) => location.toJson()).toList(),
    };
  }

  TripStatus tripStatusFromString(String trip) {
    switch (trip) {
      case "TripStatus.canceled":
        return TripStatus.canceled;
      case "TripStatus.waiting":
        return TripStatus.waiting;
      case "TripStatus.onTrip":
        return TripStatus.onTrip;
      case "TripStatus.passed":
        return TripStatus.passed;
      case "TripStatus.approved":
        return TripStatus.approved;
      default:
        return TripStatus.canceled;
    }
  }
}

enum TripStatus { onTrip, waiting, canceled, passed, approved }


