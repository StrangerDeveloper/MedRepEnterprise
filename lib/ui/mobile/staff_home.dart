import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';

class StaffHome extends StatelessWidget {
  const StaffHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: navigationController.currentStaffPage,
          bottomNavigationBar: _bottomCircularNotchedBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _floatingActionButton(context),
        ),
      ),
    );
  }

  _bottomCircularNotchedBar() {
    const inActiveColor = Colors.grey;
    return BottomAppBar(
      notchMargin: 8,
      elevation: 25,
      shape: const CircularNotchedRectangle(),
      child: Obx(
        () => BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: navigationController.tabIndex.value,
          selectedItemColor: active!,
          selectedLabelStyle: bodyText1,
          unselectedLabelStyle: bodyText3,
          unselectedItemColor: inActiveColor,
          onTap: onTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "Order History"),
          ],
        ),
      ),
    );
  }

  onTapped(int index) {
    navigationController.setStaffPage(index);
  }

  _floatingActionButton(context) {
    return FloatingActionButton(
      onPressed: () {
        orderController.isFabPressed.value = true;
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: active!),
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
        // child: SvgPicture.asset("assets/icons/fab_icon.svg"),
      ),
    );
  }
}
