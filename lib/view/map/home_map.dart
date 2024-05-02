import 'dart:async';
import 'dart:math';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import '../../controller/trip_view_model.dart';
import '../../model/order_trip_model.dart';
import '../../model/trip_model.dart';
import '../../utils/var.dart';
import '../../controller/home_View_Model.dart';
import 'dart:io';
import 'package:nfc_manager/nfc_manager.dart';

import '../speed.dart';
class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});
  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  var initialCameraPosition = const CameraPosition(
    target: Const.locationCompany,
    zoom: 17,
  );

  PersistentBottomSheetController? bottomSheet;

  TripModel userTrip = Get.find<TripViewModel>().getUserTrip();

  TextEditingController locationController = TextEditingController();
  MapType mapType = MapType.normal;
  bool isOnline = false;
  double bodyOpacity = 1;
  bool isStarted = false;
  double total = 3;
  bool isStartDrag = false;
  String dateTimeString = "" ;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    Future.delayed(const Duration(milliseconds: 50), () {
      bottomSheet?.close();
    });
    super.dispose();
  }
  bool? isNfcAvailable;

  PanelController panelController = PanelController();
  double totalPay = 0;
  bool showMarker=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Orders").doc("0").snapshots(),
          builder: (context, snapshot) {
            OrdersTripModel? ordersTripModel;
            if (snapshot.data != null && snapshot.data?.data() != null) {
              if ((isOnline && snapshot.data!.data()!['status'] == Const.tripStatusSearchDriver)) {
                ordersTripModel = OrdersTripModel.fromJson(snapshot.data!.data()!);
              } else if ((!isOnline && snapshot.data!.data()!['status'] == Const.tripStatusSearchDriver)) {
                ordersTripModel = null;
              } else {
                ordersTripModel = OrdersTripModel.fromJson(snapshot.data!.data()!);
              }
            }
            if (ordersTripModel != null) {
              HomeViewModel homeViewModel = Get.find<HomeViewModel>();
              // marker.removeWhere((element) => element.markerId.value =="toAddress");
              homeViewModel.setMarker(ordersTripModel.toLatLng!, "location_pin", "toAddress", "0");
              homeViewModel.setMarker(ordersTripModel.fromLatLng!, "Location_marker", "fromAddress", "0");
            } else {
              HomeViewModel homeViewModel = Get.find<HomeViewModel>();
              homeViewModel.markers.removeWhere((key, value) => key.value == "toAddress");
              homeViewModel.markers.removeWhere((key, value) => key.value == "fromAddress");
            }

            return GetBuilder<HomeViewModel>(builder: (homeViewModel) {
              return Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    initialCameraPosition: initialCameraPosition,
                    mapType: mapType,
                    onCameraMove: (_){
                      if(_.zoom>13.5){
                        showMarker = true;
                      }else{
                        showMarker = false;
                      }
                      setState(() {});
                    },
                    onMapCreated: (controller) async {
                      String mapStyle = await rootBundle.loadString('assets/map_style.json');
                      controller.setMapStyle(mapStyle);
                      homeViewModel.controller = Completer();
                      homeViewModel.controller.complete(controller);

                      /*    Utils().getMyLocation().then((value) {
                      print(value);
                      homeViewModel.setMarker(
                          value, "location_arrow_icon", "myId","0");
                      if (userTrip.tpRider == null) {
                        homeViewModel.animateCamera(value);
                      }
                      homeViewModel
                          .getLocationName(value)
                          .then((value) => Variables.currentLocation = value);
                      Variables.currentLoc = value;
                    });*/
                      if (userTrip.tpRider == null) {
                        homeViewModel.setRiderMarker();
                      } else {
                        homeViewModel.setMarker(userTrip.tpDest!.location!, "location_pin", "location_pin2", "0");
                        homeViewModel.setMarker(userTrip.tpLocation!.last.location!, "car_gry", "car_gry", "0");
                        homeViewModel.animateCamera(userTrip.tpLocation!.last.location!);
                        homeViewModel.getDrawPolylineGreen(userTrip.tpPolyLine!);
                      }
                    },
                    markers: showMarker?homeViewModel.markers.values.toSet():{},
                    polylines: homeViewModel.polyLines,
                  ),

                  StatefulBuilder(builder: (context, setstate) {
                    return Stack(
                      children: [
                        Positioned(
                          bottom: max(((ordersTripModel == null
                              ? 250
                              : ordersTripModel.status == Const.tripStatusSearchDriver
                              ? 420
                              : ordersTripModel.status == Const.tripStatusTripPaying
                              ? 465
                              : 400)*(bodyOpacity)), ordersTripModel?.status == Const.tripStatusTripStarted ? 150 : 100),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.red,
                            child: ListenLocationWidget(),
                          ),
                        ),
                        SlidingUpPanel(
                          isDraggable: true,
                          disableDraggableOnScrolling: !isStartDrag,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          defaultPanelState: PanelState.OPEN,
                          controller: panelController,
                          minHeight: ordersTripModel?.status == Const.tripStatusTripStarted ? 150 : 100,
                          onPanelSlide: (position) {
                            bodyOpacity = position;
                            setstate(() {});
                          },
                          maxHeight: ordersTripModel == null
                              ? 250
                              : ordersTripModel.status == Const.tripStatusSearchDriver
                                  ? 420
                                  : ordersTripModel.status == Const.tripStatusTripPaying
                                      ? 465
                                      : 400,
                          panelBuilder: () {
                            return SafeArea(
                              child: Opacity(
                                opacity: bodyOpacity,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onVerticalDragStart: (_) {
                                        isStartDrag = true;
                                        setstate(() {});
                                      },
                                      onVerticalDragEnd: (_) {
                                        isStartDrag = false;
                                        setstate(() {});
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.sizeOf(context).width,
                                            color: Colors.transparent,
                                            height: 30,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 5,
                                                width: 100,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                           if (ordersTripModel == null) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                LiteRollingSwitch(
                                                  //initial value
                                                  value: isOnline,
                                                  textOn: 'Online',
                                                  textOff: 'Offline',
                                                  colorOn: Colors.greenAccent[700]!,
                                                  colorOff: Colors.redAccent[700]!,
                                                  iconOn: Icons.done,
                                                  iconOff: Icons.remove_circle_outline,
                                                  textSize: 16.0,
                                                  onChanged: (bool state) {
                                                    isOnline=state;
                                                    setstate(() {});
                                                    setState(() {});
                                                  },
                                                  onTap: (){},
                                                  onDoubleTap: (){},
                                                  onSwipe:(){},
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "You Are ${isOnline ? "Online" : "Offline"}",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                                ),


                                                // InkWell(
                                                //   onTap: () {
                                                //     isOnline = !isOnline;
                                                //     setstate(() {});
                                                //     setState(() {});
                                                //     // FirebaseFirestore.instance.collection("Orders").doc("0").set({"temp":Random().nextInt(9999)},SetOptions(merge: true));
                                                //   },
                                                //   child: Container(
                                                //     width: 300,
                                                //     height: 50,
                                                //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                                //     child: Center(
                                                //         child: Text(
                                                //       "Go ${isOnline ? "Offline" : "Online"}",
                                                //       style: TextStyle(color: isOnline ? Colors.red.shade700 : Colors.green.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                                //     )),
                                                //   ),
                                                // )
                                              ],
                                            );
                                          } else if (ordersTripModel.status == Const.tripStatusSearchDriver) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "New Order!",
                                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("From: "),
                                                      Text(
                                                        ordersTripModel.fromAddress.toString(),
                                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.amber.shade700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Wrap(
                                                    alignment: WrapAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.sizeOf(context).width,
                                                        child: Text.rich(
                                                            textAlign: TextAlign.start,
                                                            TextSpan(children: [
                                                              TextSpan(
                                                                text: "To: ",
                                                              ),
                                                              TextSpan(
                                                                text: ordersTripModel.toAddress.toString(),
                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                              ),
                                                            ])),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    FirebaseFirestore.instance.collection("Orders").doc("0").update({"status": Const.tripStatusWaitingDriver});
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 50,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                                    child: Center(
                                                        child: Text(
                                                      "Accept The Order",
                                                      style: TextStyle(color: Colors.green.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Center(
                                                    child: SliderButton(
                                                      buttonColor: Colors.red.shade700,
                                                      action: () async {
                                                        FirebaseFirestore.instance.collection("Orders").doc("0").delete();
                                                        return true;
                                                      },
                                                      label: Text(
                                                        "Slide to cancel Order",
                                                        style: TextStyle(color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                                                      ),
                                                      icon: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (ordersTripModel.status == Const.tripStatusWaitingDriver) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "Customer Waiting You",
                                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Container(
                                                      width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("assets/images/profile.png"), fit: BoxFit.fitWidth),
                                                          color: Colors.grey.shade300,
                                                          borderRadius: BorderRadius.circular(100),
                                                          boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 20)]),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          ordersTripModel.userName!,
                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                                                        ),
                                                        Text(
                                                          ordersTripModel.userNumber!,
                                                          style: TextStyle(fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    FirebaseFirestore.instance.collection("Orders").doc("0").update({"status": Const.tripStatusTripStarted, "date": DateTime.now().toString()});
                                                    // isStarted = true;
                                                    // total = 3;
                                                    // while (isStarted) {
                                                    //   await Future.delayed(Duration(seconds: 3));
                                                    //   total = total + 0.75;
                                                    //   FirebaseFirestore.instance.collection("Orders").doc("0").set({"total": total}, SetOptions(merge: true));
                                                    // }
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 50,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                                    child: Center(
                                                        child: Text(
                                                      "Start The Order",
                                                      style: TextStyle(color: Colors.green.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Center(
                                                    child: SliderButton(
                                                      buttonColor: Colors.red.shade700,
                                                      action: () async {
                                                        FirebaseFirestore.instance.collection("Orders").doc("0").delete();
                                                        return true;
                                                      },
                                                      label: Text(
                                                        "Slide to cancel Order",
                                                        style: TextStyle(color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                                                      ),
                                                      icon: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (ordersTripModel.status == Const.tripStatusTripStarted) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "The Trip is Started",
                                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                                SizedBox(),
                                                Column(
                                                  children: [
                                                    Center(child: StatefulBuilder(builder: (timecontext, timeState) {
                                                      dateTimeString = printDuration(ordersTripModel!.date!.difference(DateTime.now()).abs()).toString();
                                                      Future.delayed(Duration(seconds: 1)).then((value) {
                                                        if (timecontext.mounted) {
                                                          timeState(() {});
                                                        }
                                                      });
                                                      return Text( dateTimeString);
                                                    })),
                                                    Center(child: StatefulBuilder(builder: (timecontext, timeState) {
                                                      totalPay = ordersTripModel!.date!.difference(DateTime.now()).abs().inSeconds.toDouble() * 0.25;
                                                      Future.delayed(Duration(seconds: 3)).then((value) {
                                                        if (timecontext.mounted) {
                                                          timeState(() {});
                                                        }
                                                      });
                                                      return SizedBox(
                                                        height: MediaQuery.sizeOf(context).width / 5,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(15)),
                                                              child: AnimatedFlipCounter(
                                                                thousandSeparator: ",",
                                                                decimalSeparator: ".",
                                                                fractionDigits: 2,
                                                                duration: Duration(milliseconds: 500),
                                                                value: totalPay,
                                                                suffix: " AED",
                                                                textStyle: TextStyle(fontSize: 40),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })),
                                                  ],
                                                ),
                                                SizedBox(),
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Center(
                                                    child: SliderButton(
                                                      buttonColor: Colors.red.shade700,
                                                      action: () async {
                                                        isStarted = false;
                                                        FirebaseFirestore.instance.collection("Orders").doc("0").update({"status": Const.tripStatusTripPaying});
                                                        return true;
                                                      },
                                                      label: Text(
                                                        "Slide to End The Trip",
                                                        style: TextStyle(color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
                                                      ),
                                                      icon: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (ordersTripModel.status == Const.tripStatusTripPaying) {
                                            return Column(
                                              children: [
                                                Text(
                                                  "Waiting Customer To Pay",
                                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.sizeOf(context).width / 2.2,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Total Time"),
                                                            Spacer(),
                                                            Text( dateTimeString),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: Colors.grey.shade300,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("subtotal"),
                                                            Spacer(),
                                                            Text(totalPay.toString() + " AED"),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: Colors.grey.shade300,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Add 5% VAT"),
                                                            Spacer(),
                                                            Text((totalPay * 0.05).toStringAsFixed(2) + " AED"),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: Colors.grey.shade300,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Total"),
                                                            Spacer(),
                                                            Text((totalPay + (totalPay * 0.05)).toStringAsFixed(2) + " AED"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Future.sync(() async {
                                                      isNfcAvailable = (Platform.isAndroid||Platform.isIOS)&&await NfcManager.instance.isAvailable();
                                                      setState(() {});
                                                      print(isNfcAvailable);
                                                      if(isNfcAvailable!){
                                                        NfcManager.instance.startSession(
                                                          onError: (_)
                                                            async {
                                                              print(_.message);
                                                              print(_.type);
                                                              print(_.details);
                                                            },
                                                            onDiscovered: (NfcTag tag) async {
                                                          List<int> idList = tag.data["mifare"]['identifier'];
                                                          String id ='';
                                                          for(var e in idList){
                                                            if(id==''){
                                                              id="${e.toRadixString(16).padLeft(2,"0")}";
                                                            }else{
                                                              id="$id:${e.toRadixString(16).padLeft(2,"0")}";
                                                            }
                                                          }
                                                          var cardId=id.toUpperCase();
                                                          print('id: '+id);
                                                          await NfcManager.instance.stopSession();
                                                          if(cardId =="04:36:56:FA:4C:78:80"){
                                                            print("object");
                                                            double userBalance = 0;
                                                            await FirebaseFirestore.instance.collection("Account").doc("0").get().then((event) {
                                                              userBalance = double.parse(event.data()!['balance'].toString());
                                                            });
                                                            if(userBalance-(totalPay + (totalPay * 0.05))>0){
                                                              FirebaseFirestore.instance.collection("Account").doc("0").update({"balance":(userBalance-(totalPay + (totalPay * 0.05))).toString()});
                                                              FirebaseFirestore.instance.collection("Orders").doc("0").delete();
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                content: Text("Payment completed successfully"),
                                                              ));
                                                            }else{
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                content: Text("User don't have enough balance"),
                                                              ));
                                                            }
                                                          }
                                                          else{
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                              content: Text("Card is Not registered"),
                                                            ));
                                                          }
                                                        });
                                                      }
                                                    });

                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 50,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                                    child: Center(
                                                        child: Text(
                                                      "Pay With Saqr Card",
                                                      style: TextStyle(color: Colors.blueAccent.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    FirebaseFirestore.instance.collection("Orders").doc("0").delete();
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 50,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                                    child: Center(
                                                        child: Text(
                                                      "User Pay Cash",
                                                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              color: Colors.blueGrey,
                                              child: Center(
                                                child: Text(
                                                  ordersTripModel!.status.toString(),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          collapsed: SafeArea(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onVerticalDragStart: (_) {
                                    isStartDrag = true;
                                    setstate(() {});
                                  },
                                  onVerticalDragEnd: (_) {
                                    isStartDrag = false;
                                    setstate(() {});
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        color: Colors.transparent,
                                        height: 30,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 5,
                                            width: 100,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Builder(builder: (context) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent.shade700,
                                        ),
                                      );
                                    } else if (ordersTripModel == null) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: isOnline ? Colors.green.shade700 : Colors.red.shade700,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "You Are ${isOnline ? "Online" : "Offline"}",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                          ),
                                        ],
                                      );
                                    } else if (ordersTripModel.status == Const.tripStatusSearchDriver) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "New Order!",
                                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              FirebaseFirestore.instance.collection("Orders").doc("0").update({"status": Const.tripStatusWaitingDriver});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              height: 50,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                              child: Center(
                                                  child: Text(
                                                "Accept The Order",
                                                style: TextStyle(color: Colors.green.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (ordersTripModel.status == Const.tripStatusWaitingDriver) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Watting You!",
                                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              FirebaseFirestore.instance.collection("Orders").doc("0").update({"status": Const.tripStatusTripStarted});
                                              isStarted = true;
                                              total = 3;
                                              while (isStarted) {
                                                await Future.delayed(Duration(seconds: 3));
                                                total = total + 0.75;
                                                FirebaseFirestore.instance.collection("Orders").doc("0").set({"total": total}, SetOptions(merge: true));
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              height: 50,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
                                              child: Center(
                                                  child: Text(
                                                "Start The Order",
                                                style: TextStyle(color: Colors.green.shade700, fontSize: 22, fontWeight: FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (ordersTripModel.status == Const.tripStatusTripStarted) {
                                      return  Center(child: StatefulBuilder(builder: (timecontext, timeState) {
                                        Future.delayed(Duration(seconds: 3)).then((value) {
                                          if (timecontext.mounted) {
                                            timeState(() {});
                                          }
                                        });
                                        return SizedBox(
                                          height: MediaQuery.sizeOf(context).width / 5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(15)),
                                                child: AnimatedFlipCounter(
                                                  thousandSeparator: ",",
                                                  decimalSeparator: ".",
                                                  fractionDigits: 2,
                                                  duration: Duration(milliseconds: 500),
                                                  value: totalPay,
                                                  suffix: " AED",
                                                  textStyle: TextStyle(fontSize: 40),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }));
                                    } else if (ordersTripModel.status == Const.tripStatusTripPaying) {
                                      return Text(
                                        "Waiting Customer To Pay: " + (totalPay + (totalPay * 0.05)).toStringAsFixed(2) + " AED",
                                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.blueGrey,
                                        child: Center(
                                          child: Text(
                                            ordersTripModel!.status.toString(),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  })
                ],
              );
            });
          }),
    );
  }
}
