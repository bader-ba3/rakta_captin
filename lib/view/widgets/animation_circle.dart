import 'dart:math';
import 'package:flutter/material.dart';


import '../../utils/app_layout.dart';
import '../../utils/app_style.dart';

class AnimationCircle extends StatefulWidget {
  const AnimationCircle({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimationCircleState createState() => _AnimationCircleState();
}

class _AnimationCircleState extends State<AnimationCircle>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController!.forward();
        } else if (status == AnimationStatus.completed) {
          _animationController!.repeat();
        }
      });

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(

      painter: MyCustomPainter(_animation!.value),
      child:  Center(
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppLayout.getHeight(15),
              horizontal: AppLayout.getWidth(15),
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: Image.asset(
              "assets/taxi _start_icon.png",
              height: AppLayout.getHeight(60),
              width: AppLayout.getWidth(60),
              color: primary,
            )),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double animationValue;

  MyCustomPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 3; value >= 0; value--) {
      canvas.drawColor(Colors.white, BlendMode.softLight);
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height),
          value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()

      ..color = const Color(0xff0f3b7f)
          .withOpacity((1 - (value / 4)).clamp(.0, 1));

    canvas.drawCircle(rect.center,
        sqrt((rect.width * .5 * rect.width * .5) * value / 4), paint);

  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }
}
