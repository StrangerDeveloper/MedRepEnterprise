import 'package:flutter/material.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/ui/web/widgets/horizontal_menu_item.dart';
import 'package:ikram_enterprise/ui/web/widgets/vertical_menu_item.dart';



class SideMenuItem extends StatelessWidget {
  final String? itemName;
  final GestureTapCallback? onTap;

  const SideMenuItem({ Key? key,@required this.itemName,@required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(ResponsiveWidget.isLargeScreen(context)){
      return VerticalMenuItem(itemName: itemName!, onTap: onTap!,);
    }else{
      return HorizontalMenuItem(itemName: itemName!, onTap: onTap!,);
    }
  }
}