import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/ui/web/overview/widgets/order_section_page.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              OrderSectionPage(),

              //AvailableDriversTable(),
            ],
          ),
        ),
      ],
    );
  }
}
