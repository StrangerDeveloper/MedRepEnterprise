import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({Key? key, required this.onTap, required this.text})
      : super(key: key);
  final GestureTapCallback? onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: lightGrey!,
                offset: const Offset(0, 1),
                blurRadius: 5,
              ),
            ]),
        child: Center(
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: bodyText3,
          ),
        ),
      ),
    );
  }
}
