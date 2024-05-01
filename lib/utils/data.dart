import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/location_model.dart';
import '../model/user_model.dart';



List<UserModel> users = [
  UserModel(
      userId: "user1708164790401255",
      userName: "User1",
      userLocation: LocationModel(
        location: const LatLng(37.322968438178506, -122.01998321906808),
      ),
      userEmail: "u1@g.com",
      userRider: false,
      userPhone: "121234",
      userState: "ON",
      userImage: "https://engineering.unl.edu/images/staff/Kayla-Person.jpg"),
  UserModel(
      userId: "Rider1708164790402045",
      userName: "Rider1",
      userLocation: LocationModel(
        location: const LatLng(37.33065543898043, -122.04141377216445),
      ),
      userEmail: "u2@g.com",
      userRider: true,
      userPhone: "2315",
      userState: "ON",
      userCar: "Tesla (4 seaters)",
      userImage: "https://engineering.unl.edu/images/staff/Emili_Jones.jpg"),
  UserModel(
      userId: "Rider1708164790402053",
      userName: "Rider2",
      userLocation: LocationModel(
        location: const LatLng(37.33430996139864, -122.0322162901144),
      ),
      userEmail: "u3@g.com",
      userRider: true,
      userPhone: "333",
      userState: "ON",
      userCar: "Toyota (4 seaters)",
      userImage:
          "https://engineering.unl.edu/images/news/headline_images/Gibson_220916_a.jpg"),
  UserModel(
      userId: "Rider1708164790402055",
      userName: "Rider3",
      userLocation: LocationModel(
        location: const LatLng(25.793037488372565, 55.94915611603593),
      ),
      userEmail: "u3@g.com",
      userRider: true,
      userPhone: "333",
      userState: "ON",
      userCar: "Toyota (4 seaters)",
      userBearing: "180",
      userImage:
          "https://engineering.unl.edu/images/news/headline_images/Gibson_220916_a.jpg"),
  UserModel(

      userId: "Rider1708164790402056",
      userName: "Rider4",
      userLocation: LocationModel(
        location: const LatLng(25.79350032446194, 55.9464631937426),
      ),
      userEmail: "u3@g.com",
      userBearing: "0",
      userRider: true,
      userPhone: "333",
      userState: "ON",
      userCar: "Toyota (4 seaters)",
      userImage:
          "https://engineering.unl.edu/images/news/headline_images/Gibson_220916_a.jpg"),
  UserModel(

      userId: "Rider1708164790402011",
      userName: "Rider5",
      userLocation: LocationModel(
        location: const LatLng(25.783678470924848, 55.969297970254694),
      ),
      userEmail: "u3@g.com",
      userBearing: "-50",
      userRider: true,
      userPhone: "333",
      userState: "ON",
      userCar: "Bus (4 seaters)",
      userImage:
          "https://engineering.unl.edu/images/news/headline_images/Gibson_220916_a.jpg"),
];
