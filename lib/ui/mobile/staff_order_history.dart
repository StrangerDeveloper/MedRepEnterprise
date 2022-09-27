import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/ui/mobile/widgets/single_staff_order_list_item.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/ui/web/widgets/not_found_data_widget.dart';

class StaffOrderHistory extends StatelessWidget {
  const StaffOrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: active,
        elevation: 0,

        title: Text(
          "Completed Orders",
          style: headline4.copyWith(color: colorLight),
        ),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            onChanged: (value) =>
                orderController.handleCompleteListSearch(value.toLowerCase()),
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
        Obx(() => orderController.staffCompleteOrdersList.isEmpty
            ? const NoDataFound()
            : orderController.staffCompleteSearchList.isNotEmpty
                ? _buildBuilderListView(orderController.staffCompleteSearchList)
                : _buildBuilderListView(
                    orderController.staffCompleteOrdersList)),
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
          return SingleStaffOrderListItem(model: model, calledFrom: "history",);
        },
      ),
    );
  }
}
