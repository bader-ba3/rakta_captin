import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../../utils/data.dart';
import '../../utils/var.dart';

class UserViewModel extends GetxController {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection(Const.userCollection);

  UserViewModel() {
    getUsers();



    // users.forEach((element) {
    //   addUser(element);
    //
    // });
  }
  final Map<String, UserModel> _userMap = {};

  Map<String, UserModel> get userMap => _userMap;

  getUsers() {
    _userCollectionRef.get().then((value) {
      for (var element in value.docs) {
        _userMap[element.id] =
            UserModel.fromJson(element.data() as Map<String, dynamic>);
      }
    });
  }

  addUser(UserModel userModel) async {
    _userCollectionRef
        .doc(userModel.userId)
        .set(userModel.toJson(), SetOptions(merge: true))
        .then(
      (_) {
        Get.snackbar(
            "Added successfully", "User : ${userModel.toJson()} added");
      },
    );
  }
}
