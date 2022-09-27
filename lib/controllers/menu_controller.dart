import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/ui/web/routing/routes.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = overviewPageDisplayName.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case overviewPageDisplayName:
        return _customIcon(Icons.trending_up, itemName);
      case productPageDisplayName:
        return _customIcon(Icons.note_rounded, itemName);
      case staffPageDisplayName:
        return _customIcon(Icons.dashboard_customize, itemName);
      case orderPageDisplayName:
        return _customIcon(Icons.inventory, itemName);

      case clientPageDisplayName:
        return _customIcon(Icons.people, itemName);
      case areaPageDisplayName:
        return _customIcon(Icons.location_city, itemName);

      case authenticationPageDisplayName:
        return _customIcon(Icons.exit_to_app, itemName);

      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: dark!);

    return Icon(
      icon,
      color: isHovering(itemName) ? dark! : lightGrey!,
    );
  }
}
