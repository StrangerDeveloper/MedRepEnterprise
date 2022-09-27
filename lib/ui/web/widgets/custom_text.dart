import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final TextStyle? textStyle;
  final FontWeight? weight;
  final TextAlign? textAlign;

  const CustomText(
      {Key? key,
      required this.text,
      this.textStyle,
      this.size,
      this.color,
      this.textAlign,
      this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: textAlign ?? TextAlign.start,
      style: textStyle ??
          TextStyle(
              fontSize: size ?? 16,
              color: color ?? Colors.black,
              fontWeight: weight ?? FontWeight.normal),
    );
  }
}
