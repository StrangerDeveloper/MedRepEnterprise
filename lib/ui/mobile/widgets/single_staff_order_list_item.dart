import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/models/place_order_model.dart';
import 'package:ikram_enterprise/ui/mobile/order/pick_product_ui.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';

class SingleStaffOrderListItem extends StatelessWidget {
  const SingleStaffOrderListItem({Key? key, this.model, this.calledFrom})
      : super(key: key);
  final PlaceOrderModel? model;
  final String? calledFrom;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          dataCell(model!.areaCode),
          dataCell(model!.customerId),
          dataCell(model!.orderBy),
          dataCell(AppConstant.formatDateTime("dd-MMM-yy hh:mm a",
              timestamp: model!.orderDateTime!)),
          dataCell(model!.isOrderCompleted! ? "Completed" : "InProcess"),
          dataCellAction(model!, context),
        ],
      ),
    );
  }

  Widget dataCell(value) {
    return Expanded(
      child: Center(
        child: CustomText(
          text: "$value",
          textStyle: caption.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget dataCellAction(PlaceOrderModel model, context) {
    return Expanded(
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () => showProductsDialog(model, context),
              child: Tooltip(
                message: "View Products",
                child: Icon(
                  Icons.view_list_rounded,
                  size: 20,
                  color: colorTeal,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  void showProductsDialog(PlaceOrderModel model, context) {
    orderController.productList.bindStream(
        orderController.getOrderProductsByUserId(model, calledFrom));
    var dialogHeight = MediaQuery.of(context).size.height * 0.5;
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
            calledFrom == "inProgress"
                ? Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      onTap: () {
                        Get.bottomSheet(
                          PickProductsUI(
                            existingOrderDocID: model.customerId!,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                      text: "Add Product",
                      width: 100,
                      height: 30,
                      color: active!,
                    ),
                  )
                : Container(),
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
                            child: Stack(
                              children: [
                                ListTile(
                                  title: CustomText(
                                    text: orderModel.pName,
                                    textStyle: headline6,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text:
                                            "Qty: ${orderModel.orderQuantity}",
                                        textStyle: bodyText1,
                                      ),
                                      CustomText(
                                        text: "bonus: ${orderModel.bonus}",
                                        textStyle: bodyText1,
                                      ),
                                      CustomText(
                                        text: "Extra: ${orderModel.extra}",
                                        textStyle: bodyText1,
                                      ),
                                      CustomText(
                                        text: "Net: ${orderModel.net ?? 0}",
                                        textStyle: bodyText1,
                                      ),
                                      orderModel.remarks != null
                                          ? CustomText(
                                              text:
                                                  "Remarks: ${orderModel.remarks}",
                                              textStyle: bodyText1,
                                            )
                                          : Container()
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
                                calledFrom == "inProgress"
                                    ? Positioned(
                                        top: 1,
                                        right: 1,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                orderController
                                                        .productQtyController
                                                        .text =
                                                    orderModel.orderQuantity!;
                                                orderController
                                                    .productBonusController
                                                    .text = orderModel.bonus!;
                                                orderController
                                                    .productExtraController
                                                    .text = orderModel.extra!;
                                                orderController
                                                    .productNetController
                                                    .text = orderModel.net!=null?orderModel.net!: "0";

                                                orderController
                                                    .productRemarksController
                                                    .text = orderModel.remarks!=null?orderModel.remarks!:"";

                                                AppConstant
                                                    .showOrderMoreDetailsDialog(
                                                        orderModel: orderModel,
                                                        dialogHeight:
                                                            dialogHeight);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: active!,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () => orderController
                                                  .deleteProductById(
                                                      model, orderModel),
                                              child: Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: colorRed!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
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
