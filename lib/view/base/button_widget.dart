import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final double? width;
  final String? text;
  final Color color;
  final bool isFilled;
  final Widget? icon;
  final Color? backgroundColor;
  final Null Function()? onTap;
  const ButtonWidget({super.key, this.width, required  this.isFilled, required  this.color,  this.text, this.icon, this.backgroundColor, this.onTap });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    if(widget.isFilled){
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Container(
          width: widget.width??MediaQuery.sizeOf(context).width/2.2,
          height: 80,
          decoration: BoxDecoration(  boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            )],borderRadius: BorderRadius.circular(8),color: widget.backgroundColor,border: Border.all(color: Colors.black,width: 2)),
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(widget.text!=null)
              Text(widget.text!,style: TextStyle(color: widget.color,fontWeight: FontWeight.w400,fontSize: 30),),
              if(widget.icon!=null)
               widget.icon!
            ],
          )),
        ),
      );
    }else {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Container(
          width: widget.width??MediaQuery.sizeOf(context).width/2.2,
          height: 80,

          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                )],
              borderRadius: BorderRadius.circular(8),color: Colors.transparent,border: Border.all(color: widget.color,width: 2)),
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(widget.text!=null)
              Text(widget.text!,style: TextStyle(color: widget.color,fontWeight: FontWeight.w400,fontSize: 30),),
              if(widget.icon!=null)
                widget.icon!
            ],
          )),
        ),
      );
    }
  }
}
