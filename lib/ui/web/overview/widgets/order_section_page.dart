import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/ui/web/overview/widgets/custom_chips.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OrderSectionPage extends StatelessWidget {
  const OrderSectionPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey!.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey!, width: .5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text:
                "${orderController.pageCalledFor! ? "InProgress " : "Completed "}Orders",
            textStyle: headline5.copyWith(color: lightGrey),
          ),
          /*Obx(
            () =>
          ),*/
          const SizedBox(
            height: 5,
          ),

          /// Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 2, child: Container()),
              Obx(
                () => Expanded(
                  flex: 2,
                  child: CustomChip(
                    onTap: () => showCalendarDialog(context),
                    text:
                        "DateRange: \n ${orderController.selectedStartAndEndDateRange}",
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: FormInputFieldWithIcon(
                  controller: orderController.searchController,
                  iconPrefix: Icons.search,
                  labelText: 'Searching...',
                  hint: "Search with Staff/Booker or Area or Customer",
                  iconColor: active!,
                  autofocus: false,
                  textStyle: bodyText1,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => orderController.pageCalledFor!
                      ? orderController
                          .handleInProgressListSearch(value.toLowerCase())
                      : orderController
                          .handleCompleteListSearch(value.toLowerCase()),
                  onSaved: (value) => {},
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          orderController.pageCalledFor!
              ? Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onTap: () => orderController.exportOrderProducts(),
                      text: "Export all orders",
                      width: 150,
                      height: 40,
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      onTap: () =>
                          orderController.completeAllInProgressOrders(),
                      text: "Complete all orders",
                      width: 150,
                      height: 40,
                      color: dark,
                    )
                  ],
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomOrderDataTable(),
          ),
        ],
      ),
    );
  }

  void showCalendarDialog(context) {
    showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Select Date Range",
              style: headline6,
            ),
            actions: [
              MaterialButton(
                child: Text(
                  "Apply",
                  style: caption.copyWith(color: active),
                ),
                onPressed: () {
                  orderController.pageCalledFor!
                      ? orderController.searchInProgressListByDate()
                      : orderController.searchCompleteListByDate();
                  Get.back();
                  if (orderController.pageCalledFor!) {
                    if (orderController.inProgressSearchList.isEmpty) {
                      AppConstant.displayNormalSnackBar("Search Alert!",
                          "No data found in selected Date Range \nShowing Default List ");
                    }
                  } else if (orderController.completedSearchList.isEmpty) {
                    AppConstant.displayNormalSnackBar("Search Alert!",
                        "No data found in selected Date Range\nShowing Default List ");
                  }
                },
              )
            ],
            content: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: lightGrey!,
                ),
              ]),
              child: SfDateRangePicker(
                allowViewNavigation: true,
                enablePastDates: true,
                rangeTextStyle: bodyText3.copyWith(color: colorLight!),
                startRangeSelectionColor: active!,
                endRangeSelectionColor: active!,
                rangeSelectionColor: active!.withOpacity(.6),
                onSelectionChanged: orderController.onDateSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            ),
          );
        });
  }
}

class CustomOrderDataTable extends StatelessWidget {
  const CustomOrderDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///columns
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: orderController.orderColumnsHeader
                  .map(
                    (value) => Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: CustomText(
                            text: value,
                            textStyle: headline5.copyWith(color: colorGreen),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => !orderController.pageCalledFor!
              ? orderController.completedSearchList.isNotEmpty
                  ? _buildBuilderListView(orderController.completedSearchList)
                  : _buildBuilderListView(orderController.completedOrdersList)
              : orderController.inProgressSearchList.isNotEmpty
                  ? _buildBuilderListView(orderController.inProgressSearchList)
                  : _buildBuilderListView(orderController.inProgressOrdersList),
        )
        //: _buildMapListView(),)
        //:_buildBuilderListView(orderController.inProgressOrdersList)),
      ],
    );
  }

  Widget _buildBuilderListView(List<PlaceOrderModel> list) {

    debugPrint("Customerlist: ${customerController.customerList.length}");

    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, index) {
          PlaceOrderModel model = list[index];
          return singleListViewItem(model);
        },
      ),
    );
  }

  Widget singleListViewItem(PlaceOrderModel model) {
    return CustomContainer(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          dataCell(model.areaCode),
          dataCell(model.customerId),
          dataCell(model.orderBy),
          dataCell(AppConstant.formatDateTime("dd-MMM-yy hh:mm a",
              timestamp: model.isOrderCompleted!
                  ? model.completionDateTime!
                  : model.orderDateTime)),
          dataCell(model.isOrderCompleted! ? "Completed" : "InProcess"),
          dataCellAction(model),
        ],
      ),
    );
  }

  Widget dataCell(value) {
    return Expanded(
      child: Center(
        child: CustomText(
          text: "$value",
          textAlign: TextAlign.center,
          textStyle: bodyText3.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget dataCellAction(PlaceOrderModel model) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          orderController.pageCalledFor!
              ? InkWell(
                  onTap: () => orderController.exportSingleOrderProducts(model),
                  child: Tooltip(
                    message: "Export Products",
                    child: Icon(
                      Icons.outbond_outlined,
                      color: colorAmber,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () => showProductsDialog(model),
            child: Tooltip(
              message: "View Products",
              child: Icon(
                Icons.view_list_rounded,
                color: colorTeal,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (orderController.pageCalledFor!)
            InkWell(
              onTap: () => orderController.pushToOrderHistory(model),
              child: Tooltip(
                message: "Complete Order",
                child: Icon(
                  Icons.task,
                  color: colorPurple,
                ),
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Get.defaultDialog(
                title: "Delete Attention",
                titleStyle: headline3.copyWith(color: colorRed),
                middleText:
                    "Do you really wants to Delete\n   ${model.customerId} Order?",
                textConfirm: "Delete",
                cancel: CustomButton(
                    width: 80,
                    height: 30,
                    color: dark,
                    onTap: () => Get.back(),
                    text: "No",
                    textStyle: headline6.copyWith(color: colorLight)),
                confirm: CustomButton(
                    width: 80,
                    height: 30,
                    color: colorRed,
                    onTap: () async {
                      await orderController.deletePlacedOrder(model);
                    },
                    text: "Yes",
                    textStyle: headline6.copyWith(color: colorLight)),
              );
            },
            child: Icon(
              Icons.delete,
              color: colorRed,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void showProductsDialog(PlaceOrderModel model) {
    orderController.productList
        .bindStream(orderController.getProductsByOrderID(model));

    Get.defaultDialog(
      title: "Products View",
      titleStyle: headline4,
      barrierDismissible: false,
      cancel: CustomButton(
          width: 140,
          height: 40,
          onTap: () => Get.back(),
          text: "Close",
          textStyle: headline6.copyWith(color: colorLight)),
      content: SizedBox(
        width: 350,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              textAlign: TextAlign.start,
              text: "OrderBy: ${model.orderBy}   Customer: ${model.customerId}",
              textStyle: bodyText1.copyWith(color: active),
            ),
            Obx(
              () => orderController.productList.isEmpty
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: orderController.productList.length,
                        itemBuilder: (_, index) {
                          OrderModel orderModel =
                              orderController.productList[index];
                          return CustomContainer(
                            child: ListTile(
                              title: CustomText(
                                text: orderModel.pName,
                                textStyle:
                                    headline6.copyWith(color: colorGreen),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Code: ${orderModel.pCode}",
                                    textStyle: bodyText1,
                                  ),
                                  CustomText(
                                    text: "Qty: ${orderModel.orderQuantity}",
                                    textStyle:
                                        bodyText2.copyWith(color: lightGrey),
                                  ),
                                  CustomText(
                                    text: "bonus: ${orderModel.bonus}",
                                    textStyle:
                                        bodyText2.copyWith(color: lightGrey),
                                  ),
                                  CustomText(
                                    text: "Extra: ${orderModel.extra}",
                                    textStyle:
                                        bodyText2.copyWith(color: lightGrey),
                                  ),
                                  CustomText(
                                    text:
                                        "OrderBy: ${authController.getStaffNameByID(orderModel.orderBy!)}",
                                    textStyle:
                                        bodyText2.copyWith(color: lightGrey),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text:
                                        "Order DateTime\n ${AppConstant.formatDateTime("dd-MM-yy  hh:mm a", timestamp: orderModel.productAdditionDateTime)}",
                                    textStyle: caption,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
