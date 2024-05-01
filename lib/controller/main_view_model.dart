import 'package:get/get.dart';

class MainViewModel extends GetxController{
  int index = 0;
  updateIndex(_){
    if(_<2){
      index = _;
    }else{
      index = _-1;
    }
    update();
  }
}