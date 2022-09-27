import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.textStyle,
    this.width = double.maxFinite,
    this.height = 60,

    this.color,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final String? text;
  final TextStyle? textStyle;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap!,
      child: Container(
        decoration: BoxDecoration(
            color: color ?? active!, borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        width: width,
        height: height ,
        //padding: const EdgeInsets.symmetric(vertical: 16),
        child: CustomText(
          text: text!,
          color: Colors.white,
          textStyle: textStyle??bodyText3.copyWith(color: colorLight),
        ),
      ),
    );
  }
}
