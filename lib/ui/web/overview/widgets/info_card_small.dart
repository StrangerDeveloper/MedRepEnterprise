import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';

class InfoCardSmall extends StatelessWidget {
  final String? title;
  final String? value;
  final bool? isActive;
  final GestureTapCallback? onTap;

  const InfoCardSmall(
      {Key? key,
      required this.title,
      required this.value,
      this.isActive = false,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: isActive! ? active! : lightGrey!, width: .5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                size: 24,
                weight: FontWeight.w300,
                color: isActive! ? active! : lightGrey!,
              ),
              CustomText(
                text: value,
                size: 24,
                weight: FontWeight.bold,
                color: isActive! ? active! : dark!,
              )
            ],
          ),
        ),
      ),
    );
  }
}
