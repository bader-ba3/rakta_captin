import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_layout.dart';
import '../../../utils/app_style.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 1 / 2.6,
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
                  "Where to?",
                  style: Styles.textStyle
                      .copyWith(color: Colors.black, fontSize: 20),
                ),
                const Spacer(),
                Text(
                  "MANAGE",
                  style: Styles.textStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: AppLayout.getHeight(25),
            ),
            SizedBox(
              width: Get.width,
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 175,
                    width: 150,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                            padding: EdgeInsets.symmetric(
                              vertical: AppLayout.getHeight(15),
                              horizontal: AppLayout.getWidth(15),
                            ),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Image.asset(
                              "assets/location_icon.png",
                              height: AppLayout.getHeight(30),
                              width: AppLayout.getWidth(30),
                              color: primary,
                            )),
                        const Spacer(),
                        Text(
                          "Destination",
                          style: Styles.textStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Enter Destination",
                          style: Styles.textStyle
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: AppLayout.getWidth(10),
                  ),
                  SizedBox(
                    width: 170 * 1,
                    height: 175,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return Container(
                            height: 175,
                            width: 150,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: primary.withOpacity(0.5),
                                      blurRadius: 5,
                                      blurStyle: BlurStyle.outer)
                                ]),
                            child: Column(
                              children: [
                                const Spacer(),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppLayout.getHeight(15),
                                      horizontal: AppLayout.getWidth(15),
                                    ),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: Image.asset(
                                      "assets/office_icon.png",
                                      height: AppLayout.getHeight(30),
                                      width: AppLayout.getWidth(30),
                                      color: Colors.white,
                                    )),
                                const Spacer(),
                                Text(
                                  "Destination",
                                  style: Styles.textStyle.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Enter Destination",
                                  style: Styles.textStyle
                                      .copyWith(color: primary, fontSize: 12),
                                ),
                                const Spacer(),
                              ],
                            ),
                          );
                        }),
                  ),



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
