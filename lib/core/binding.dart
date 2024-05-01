import 'package:get/get.dart';
import '../controller/main_view_model.dart';
import '../controller/place_view_model.dart';
import '../controller/trip_view_model.dart';
import '../controller/user_view_model.dart';
import '../controller/home_View_Model.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlaceViewModel(),);
    Get.put(MainViewModel());
    Get.put(TripViewModel());
    Get.put(UserViewModel());
    Get.put(HomeViewModel());
    // Get.lazyPut(() => HomeViewModel(),fenix: true);
    // Get.lazyPut(() => RiderHomeViewModel(),fenix: true);
    // Get.lazyPut(() => TripHistoryViewModel(),fenix: true);
  }
}
