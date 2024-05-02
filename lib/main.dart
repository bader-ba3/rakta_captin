import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rakta_captin/core/binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/map/home_map.dart';

main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.location.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GetBinding(),
    home:HomeMapPage()
    //   home: MainApp(),
    );
  }
}
