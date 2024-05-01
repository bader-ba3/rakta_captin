import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



import '../model/location_model.dart';
import '../model/trip_model.dart';
import '../utils/var.dart';
import 'home_View_Model.dart';

class TripViewModel extends GetxController {
  final CollectionReference _tripCollectionRef =
      FirebaseFirestore.instance.collection(Const.tripCollection);

  TripViewModel() {
    getTrip();
  }

  final Map<String, TripModel> _tripMap = {};

  Map<String, TripModel> get tripMap => _tripMap;
  TripModel _currentTrip = TripModel();

  TripModel get currentTrip => _currentTrip;

  final TripModel _userTrip = TripModel();

  TripModel get userTrip => _userTrip;

  TripModel getUserTrip() {
    TripModel trip = TripModel();
    for (var cTrip in _tripMap.values) {
      if (cTrip.tpUser == Variables.currentUser.userId &&
          (cTrip.tpStatus == TripStatus.onTrip ||
              cTrip.tpStatus == TripStatus.approved)) {
        trip = cTrip;
      }
    }
    return trip;
  }

  getTrip() {
    _tripCollectionRef.snapshots().listen((event) {
      _tripMap.clear();
      for (var element in event.docs) {
        _tripMap[element.id] =
            TripModel.fromJson(element.data() as Map<String, dynamic>);
      }
      getUserTrip();
      update();
    });
  }

  addTrip(TripModel tripModel) {
    _tripCollectionRef.doc(tripModel.tpId).set(
          tripModel.toJson(),
          SetOptions(merge: true),
        );
  }

  acceptTrip(TripModel tripModel) {
    _tripCollectionRef.doc(tripModel.tpId).set(
      {
        "tpLocation": FieldValue.arrayUnion(
            tripModel.tpLocation!.map((e) => e.toJson()).toList()),
        "tpRider": tripModel.tpRider,
        "tpStatus": tripModel.tpStatus.toString(),
      },
      SetOptions(merge: true),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var _listener;

  listenTripById(String tripId) {
    var tr = true;
    var homeController = Get.find<HomeViewModel>();
    _listener = _tripCollectionRef.doc(tripId).snapshots().listen((event) {
      if (event.data() != null) {
        _currentTrip = TripModel.fromJson(event.data() as Map<String, dynamic>);
        homeController.update();
        if (_currentTrip.tpStatus == TripStatus.approved ||
            _currentTrip.tpStatus == TripStatus.onTrip) {
          if (tr) {
            homeController.cleaMarkers();
            homeController.setMarker(
                _currentTrip.tpSrc!.location!, "location_arrow_icon", "user","0");
            homeController.setMarker(
                _currentTrip.tpDest!.location!, "location_pin", "userDest","0");
            homeController.update();
            Fluttertoast.showToast(msg: "جييك");
            tr = false;
          }
          homeController.animateCamera(_currentTrip.tpLocation!.last.location!);
          homeController.setMarker(
              _currentTrip.tpLocation!.last.location!, "car_gry", "Rider1","0");
        }
        if (_currentTrip.tpStatus == TripStatus.canceled ||
            _currentTrip.tpStatus == TripStatus.passed) {
          _listener.cancel();
        }
      } else {
        _currentTrip.tpStatus == TripStatus.canceled;
        _listener.cancel();
        homeController.update();
      }
    });
  }

  sendLocationToTrip(List<LatLng> location, TripModel tripModel) {
    for (var loc in location) {
      _tripCollectionRef.doc(tripModel.tpId).set(
        {
          "tpLocation":
              FieldValue.arrayUnion([LocationModel(location: loc).toJson()]),
          "tpStatus": TripStatus.approved.toString(),
        },
        SetOptions(merge: true),
      );
    }
  }

  editTrip(TripModel tripModel) {
    _tripCollectionRef.doc(tripModel.tpId).set(
          tripModel.toJson(),
          SetOptions(merge: true),
        );
  }

  getTripUser(String uId) {
    List<TripModel> list=[];

    _tripCollectionRef.snapshots().listen((event) {
      for(var trip in event.docs){
        var uTrip=TripModel.fromJson(trip.data() as Map<String,dynamic>);
        if( uTrip.tpUser==uId){
          list.add(uTrip);
        }

      }
    });
    return list;
  }
}
