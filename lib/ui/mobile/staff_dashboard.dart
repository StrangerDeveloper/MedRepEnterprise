import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/ui/mobile/order/place_order_ui.dart';
import 'package:ikram_enterprise/ui/mobile/profile/profile_ui.dart';
import 'package:ikram_enterprise/ui/mobile/widgets/circular_avatar.dart';
import 'package:ikram_enterprise/ui/mobile/widgets/single_staff_order_list_item.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/ui/web/widgets/not_found_data_widget.dart';

class StaffDashboardUI extends StatelessWidget {
  const StaffDashboardUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: active!,
      resizeToAvoidBottomInset: false,
      body: _body(context),
    );
  }

  Widget _body(context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Header profile icon and Dashboard Text...
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: RichText(
                        text: TextSpan(
                          text: 'Dashboard \n',
                          style: headline3,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Welcome ${authController.userModel!.name}',
                              style: GoogleFonts.montserrat(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //profile icon
                    InkWell(
                      onTap: () {
                        Get.to(() => const ProfileUI());
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        child: Obx(
                          () => CircularAvatar(
                            padding: 1,
                            imageUrl: authController.userModel!.photoUrl!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //FormVerticalSpace(),
                const Spacer(),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.15,
              ),
              Expanded(
                child: CustomContainer(
                  margin: const EdgeInsets.only(top: 5),
                  //height: constraints.maxHeight,
                  isDashboardBody: true,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                  child: Obx(() => orderController.isFabPressed.isFalse
                      ? _displayOrders()
                      : const PlaceOrderUI()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _displayOrders() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: "Recent Orders",
          textStyle: headline4,
        ),

        ///Search Box
        Container(
          margin: const EdgeInsets.all(15),
          child: FormInputFieldWithIcon(
            controller: orderController.staffSearchController,
            iconPrefix: Icons.search,
            labelText: 'Search',
            hint: "Search with Area or Customer",
            iconColor: active!,
            autofocus: false,
            textStyle: bodyText1,
            keyboardType: TextInputType.text,
            onChanged: (value) => orderController
                .handleStaffInProgressSearch(value.toLowerCase()),
            onSaved: (value) => {},
          ),
        ),

        ///columns
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: orderController.staffOrderColumnsHeader
                  .map(
                    (value) => Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: CustomText(
                            text: value,
                            textStyle: bodyText3.copyWith(color: colorGreen),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Obx(() => orderController.staffInProgressOrdersList.isEmpty
            ? const NoDataFound()
            : orderController.staffInProgressSearchList.isNotEmpty
                ? _buildBuilderListView(
                    orderController.staffInProgressSearchList)
                : _buildBuilderListView(
                    orderController.staffInProgressOrdersList)),
      ],
    );
  }

  Widget _buildBuilderListView(List<PlaceOrderModel> list) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, index) {
          PlaceOrderModel model = list[index];
          return SingleStaffOrderListItem(model:model, calledFrom: "inProgress",);
        },
      ),
    );
  }


}
