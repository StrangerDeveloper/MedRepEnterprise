import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/ui/web/routing/routes.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
            decoration: BoxDecoration(
              color: colorLight,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 3.0,
                ),
              ],
            ),
            child: ListView(
              children: [
                if(ResponsiveWidget.isSmallScreen(context))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        SizedBox(width: width / 48),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset("assets/icons/logo.png"),
                        ),
                        Flexible(
                          child: CustomText(
                            text: "Dashboard",
                            size: 20,
                            weight: FontWeight.bold,
                            color: active!,
                          ),
                        ),
                        SizedBox(width: width / 48),
                      ],
                    ),
                   const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                    Divider(color: lightGrey!.withOpacity(.1), ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sideMenuItemRoutes
                      .map((item) => SideMenuItem(
                          itemName: item.name,
                          onTap: () {
                            if(item.route == authenticationPageRoute){
                              Get.offAllNamed(authenticationPageRoute);
                              menuController.changeActiveItemTo(overviewPageDisplayName);

                            }
                            if (!menuController.isActive(item.name)) {
                              menuController.changeActiveItemTo(item.name);
                              if(ResponsiveWidget.isSmallScreen(context)) {
                                Get.back();
                                //navigationController.navigateTo(item.route);
                              }
                              navigationController.navigateTo(item.route);
                              //Get.to(item.route);
                            }
                          }))
                      .toList(),
                )
              ],
            ),
          );
  }
}