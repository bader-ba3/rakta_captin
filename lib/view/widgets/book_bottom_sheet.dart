import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../model/trip_model.dart';
import '../../../Services/services.dart';
import '../../../utils/app_style.dart';
import 'app_Bottom.dart';

// ignore: must_be_immutable
class RequestBottomSheet extends StatelessWidget {
  RequestBottomSheet({super.key, required this.userTrip});

  TripModel userTrip;

  @override
  Widget build(BuildContext context) {
    String distance = Utils()
        .calculateDistance(
            userTrip.tpLocation!.last.location!, userTrip.tpSrc!.location!)
        .round()
        .toString();
    return Container(
      height: Get.height * 1 / 3.5,
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5)
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Rider Founded",
                  style: Styles.textStyle
                      .copyWith(color: Colors.black, fontSize: 20),
                ),
                const Spacer(),
                Text(
                  "$distance min Away",
                  style:
                      Styles.textStyle.copyWith(fontSize: 12, color: primary),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 25, backgroundColor: primary.withOpacity(0.3)),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        "Jenny Wilson",
                        style: Styles.headLineStyle4
                            .copyWith(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        "Toyota(4 seater)",
                        style: Styles.headLineStyle4.copyWith(fontSize: 12),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Spacer(),
                      Text(
                        "\$1.25/per mile",
                        style: Styles.headLineStyle4.copyWith(fontSize: 12),
                      ),
                      Text(
                        userTrip.tpRider.toString(),
                        style: Styles.headLineStyle4.copyWith(fontSize: 12),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: AppButton(
                    label: userTrip.tpStatus == TripStatus.approved
                        ? "وصل"
                        : "وصلني"))
          ],
        ),
      ),
    );
  }
}
