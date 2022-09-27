import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/customer_model.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/ui/mobile/order/pick_product_ui.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';

class PlaceOrderUI extends StatelessWidget {
  const PlaceOrderUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authController.setBtnState(0);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: ()=>orderController.clearControllers(),
                  child: CustomText(text: "Cancel", textStyle: bodyText1.copyWith(color: colorRed),),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: CustomText(
                text: "Place Order",
                textStyle: headline1,
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Customer",
                textStyle: headline6,
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            /// Pick Customer
            Obx(() => customerController.isCustomerPicked!
                ? _displayCustomer()
                : _searchCustomer()),

            const SizedBox(height: 10),

            Obx(() => customerController.isCustomerPicked!
                ? _displayProducts(context)
                : Container()),

            ///Place order button
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(()=>_btnPlaceOrder()),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  _btnPlaceOrder(){
    if (authController.btnState! == 1) {
      return Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active,
        ),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2.5,
        ),
      );
    } else if (authController.btnState! == 2) {
      return Container(
          width: 45,
          height: 45,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorGreen,
          ),
          child: Icon(Icons.check, size: 30, color: colorLight));
    }

    return CustomButton(
      onTap: () async {
        if (customerController.customerModel!.code != null) {
          if (orderController.orderProductList.isNotEmpty) {
            await orderController.createOrder();
          } else {
            AppConstant.displayFailedSnackBar("Warning!",
                "at least one product should be selected");
          }
        } else {
          AppConstant.displayFailedSnackBar(
              "Warning!", "Please Select customer first!");
        }
      },
      text: "Place Order",
      width: 140,
      height: 50,
      textStyle: headline6.copyWith(color: colorLight),
      color: active!,
    );
  }

  Widget _searchCustomer() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: FormInputFieldWithIcon(
            controller: orderController.searchController,
            iconPrefix: Icons.search,
            labelText: 'Search Customer',
            hint: "Search by Customer Name/Code or Area Name/Code",
            iconColor: active!,
            autofocus: false,
            textStyle: bodyText1,
            keyboardType: TextInputType.text,
            onChanged: (value) =>
                customerController.handleCustomerSearch(value.toLowerCase()),
            onSaved: (value) => {},
          ),
        ),
        Obx(
          () => customerController.customerSearchList.isEmpty
              ? const Center(
                  child: CustomText(
                    text: "Search Customer using Search Box ...",
                  ),
                )
              : SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: customerController.customerSearchList.length,
                    itemBuilder: (_, index) {
                      CustomerModel model =
                          customerController.customerSearchList[index];
                      return CustomContainer(
                        onTap: () {
                          customerController.setCustomerIsPicked(true);
                          customerController.setCustomerModel(model);
                        },
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          title: CustomText(
                            text: model.name,
                            textStyle: headline6,
                          ),
                          subtitle: CustomText(
                            text: "Address: ${model.address}",
                            textStyle: bodyText3.copyWith(
                                fontWeight: FontWeight.normal),
                          ),
                          trailing: CustomText(
                            text: "Area: ${model.areaName}",
                            textStyle: caption,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _displayCustomer() {
    return CustomContainer(
      child: Stack(
        children: [
          Obx(
            () => ListTile(
              shape: const RoundedRectangleBorder(),
              title: CustomText(
                text: customerController.customerModel!.name!,
                textStyle: headline6,
              ),
              subtitle: CustomText(
                text: "Address: ${customerController.customerModel!.address}",
                textStyle: bodyText3.copyWith(fontWeight: FontWeight.normal),
              ),
              trailing: CustomText(
                text: "Area: ${customerController.customerModel!.areaName}",
                textStyle: caption,
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -5,
            child: IconButton(
              onPressed: () => customerController.setCustomerIsPicked(false),
              icon: Icon(
                Icons.close,
                color: colorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayProducts(context) {
    var dialogHeight =  MediaQuery.of(context).size.height * 0.5;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Products",
                textStyle: headline6,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                onTap: () {
                  Get.bottomSheet(
                    const PickProductsUI(existingOrderDocID: "",),
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
            ),
          ],
        ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.orderProductList.length,
            itemBuilder: (_, index) {
              OrderModel orderModel = orderController.orderProductList[index];
              return CustomContainer(
                margin: const EdgeInsets.all(4),
                child: Stack(
                  children: [
                    ListTile(
                      title: CustomText(
                        text: orderModel.pName,
                        textStyle: headline6,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Qty: ${orderModel.orderQuantity}",
                            textStyle: bodyText2,
                          ),
                          CustomText(
                            text: "bonus: ${orderModel.bonus}",
                            textStyle: bodyText2,
                          ),
                          CustomText(
                            text: "Extra: ${orderModel.extra}",
                            textStyle: bodyText2,
                          ),

                          CustomText(
                            text: "Net: ${orderModel.net}",
                            textStyle: bodyText2,
                          ),
                          orderModel.remarks!=null?
                          CustomText(
                            text: "Remarks: ${orderModel.remarks}",
                            textStyle: bodyText2,
                          ):Container(),



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
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              orderController.productQtyController.text =
                                  orderModel.orderQuantity!;
                              orderController.productBonusController.text =
                                  orderModel.bonus!;
                              orderController.productExtraController.text =
                                  orderModel.extra!;
                                orderController.productNetController.text = orderModel.net!;
                                orderController.productRemarksController.text = orderModel.remarks!;

                                if( customerController.customerModel!.areaCode == "0" ){
                                 dialogHeight = dialogHeight -80;
                                }
                              AppConstant.showOrderMoreDetailsDialog(
                                  orderModel: orderModel, dialogHeight: dialogHeight);
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
                                .removeFromOrderProductList(orderModel),
                            child: Icon(
                              Icons.delete,
                              size: 20,
                              color: colorRed!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
