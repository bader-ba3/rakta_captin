import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



import '../../../controller/place_view_model.dart';
import '../../../model/PlaceModel.dart';
import '../../../utils/app_style.dart';
import '../../../controller/home_View_Model.dart';

class PlaceSearchPage extends StatefulWidget {
  const PlaceSearchPage({super.key});

  @override
  State<PlaceSearchPage> createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  PlaceModel placeModel = PlaceModel();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaceViewModel>(builder: (placeViewModel) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              hintStyle: Styles.headLineStyle3.copyWith(
                fontSize: 14,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              hintText: "Enter Location Name",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (value) {
              placeViewModel.getPlace(value);
              placeModel = placeViewModel.places;
              setState(() {});
            },
          ),
        ),
        body: ListView.builder(
            itemCount: placeModel.places?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.find<HomeViewModel>().animateCamera(LatLng(
                          placeModel.places![index].location!.latitude!,
                          placeModel.places![index].location!.longitude!));
                    },
                    child: ListTile(
                        title: Text(
                          placeModel.places![index].displayName!.text!
                              .toString(),
                          style: Styles.headLineStyle2,
                        ),
                        subtitle: Text(
                          placeModel.places![index].formattedAddress.toString(),
                          style: Styles.headLineStyle3,
                        )),
                  ));
            }),
      );
    });
  }
}
// placeModel.places![index].displayName!.text!.toString()
