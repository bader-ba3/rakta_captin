

import 'location_model.dart';

class UserModel {
  String? userId, userName, userState, userPhone, userEmail, userImage, userCar,userBearing;
  LocationModel? userLocation;
  List<LocationModel>? userSavedLocation;
  bool? userRider;

  UserModel({
    this.userId,
    this.userName,
    this.userLocation,
    this.userEmail,
    this.userImage,
    this.userPhone,
    this.userRider,
    this.userSavedLocation,
    this.userState,
    this.userCar,
    this.userBearing,
  });

  UserModel.fromJson(Map<String, dynamic> map) {
    userSavedLocation = [];
    userId = map['ordId'] ?? '';
    userName = map['ordUser'] ?? '';
    userLocation = LocationModel.fromJson(map['ordUserLocation'] ?? {});
    userState = map['userState'] ?? '';
    userRider = map['userRider'] ?? false;
    userPhone = map['userPhone'] ?? '';
    userImage = map['userImage'] ?? '';
    userEmail = map['userEmail'] ?? '';
    userCar = map["userCar"] ?? '';
    userBearing = map["userBearing"] ?? '0';
    for (var location in map['userSavedLocation'] ?? {}) {
      userSavedLocation?.add(LocationModel.fromJson(location));
    }
  }

  toJson() {
    return {
      if (userId != null) "ordId": userId,
      if (userName != null) "ordUser": userName,
      if (userLocation != null) "ordUserLocation": userLocation?.toJson(),
      if (userRider != null) "userRider": userRider,
      if (userState != null) "userState": userState,
      if (userPhone != null) "userPhone": userPhone,
      if (userImage != null) "userImage": userImage,
      if (userEmail != null) "userEmail": userEmail,
      if (userCar != null) "userCar": userCar,
      if (userBearing != null) "userBearing": userBearing,
      if (userSavedLocation != null)
        "userSavedLocation": userSavedLocation?.map((e) => e.toJson()).toList(),
    };
  }
}
