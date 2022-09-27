import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/ui/mobile/profile/profile_ui.dart';
import 'package:ikram_enterprise/ui/mobile/staff_dashboard.dart';
import 'package:ikram_enterprise/ui/mobile/staff_order_history.dart';
import 'package:ikram_enterprise/ui/web/order_history/order_history_ui.dart';

class NavigationController extends GetxController{
  static NavigationController instance = Get.find();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future<dynamic> navigateTo(String routeName){
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  goBack() => navigatorKey.currentState!.pop();

  final tabIndex = 0.obs;

  List<Widget> staffPages = [
    const StaffDashboardUI(),
    const StaffOrderHistory(),
    //const ProfileUI(),
  ];

  Widget get currentStaffPage => staffPages[tabIndex.value];

  void setStaffPage(index){
    tabIndex.value = index;
  }

}