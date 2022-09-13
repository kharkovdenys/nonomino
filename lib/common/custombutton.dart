import 'package:flutter/material.dart';
import 'package:nonomino/services/size_config.dart';

class CustomButton extends StatelessWidget {
  final Function() func;
  final String text;
  final double width, height, fontSize;
  final Color color;
  final BoxShape shape;

  const CustomButton({
    Key? key,
    this.width = 30,
    this.height = 80,
    required this.func,
    required this.text,
    this.fontSize = 20,
    this.color = const Color(0xd56aeaee),
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width.toWidth,
        height: height.toHeight,
        child: GestureDetector(
          onTap: func,
          child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: color,
                      shape: shape,
                      borderRadius: shape == BoxShape.rectangle
                          ? BorderRadius.circular(12)
                          : null),
                  width: width.toWidth * 0.8,
                  height: height.toHeight * 0.8,
                  child: Center(
                      child: Text(text,
                          style: TextStyle(fontSize: fontSize.toFont))))),
        ));
  }
}
