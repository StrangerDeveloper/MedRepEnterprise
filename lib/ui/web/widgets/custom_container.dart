import 'package:flutter/material.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? color;
  final bool? hasOuterShadow;
  final bool? isDashboardBody;
  final BorderRadiusGeometry? borderRadius;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin, padding;
  final GestureTapCallback? onTap;

  const CustomContainer(
      {Key? key,
      required this.child,
      this.constraints,
      this.height,
      this.width,
      this.margin,
      this.padding,
       this.borderRadius,
      this.isDashboardBody = false,
      this.hasOuterShadow = false,
      this.alignment,
      this.onTap,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: alignment,
        decoration: hasOuterShadow!
            ? boxOuterShadow(isDashboardBody, borderRadius)
            : boxNoShadow(isDashboardBody, borderRadius),
        padding: padding ?? const EdgeInsets.all(5),
        margin: margin ?? const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

BoxDecoration boxNoShadow(isNotificationBody, borderRadius) {
  return BoxDecoration(
    borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(14.3)),
    color: isNotificationBody ? Colors.grey[200]! : Colors.white,
    boxShadow: [
      BoxShadow(
        color: active!.withOpacity(0.22),
        offset: const Offset(0, 0),
        blurRadius: 10.78,
      ),
    ],
  );
}

BoxDecoration boxOuterShadow(isNotificationBody, borderRadius) {
  return BoxDecoration(
    borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(12.0)),
    color: isNotificationBody ? Colors.grey[300]! : Colors.white,
    boxShadow: [
      BoxShadow(
        color: active!.withOpacity(0.22),
        offset: const Offset(0, 1),
        blurRadius: 10.78,
      ),
    ],
  );
}

BoxDecoration bottomBarStyle() {
  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
    color: Colors.white,
    border: Border.all(color: active!, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: active!.withOpacity(0.22),
        offset: const Offset(0, 1),
        blurRadius: 10.78,
      ),
    ],
  );
}