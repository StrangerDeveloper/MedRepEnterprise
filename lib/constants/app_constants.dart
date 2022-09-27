import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/order_model.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/models/user_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_password_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class AppConstant {
  AppConstant._();

  static const String medicalRep = "Medical Representative";

  static displayFailedSnackBar(title, message) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        //backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        backgroundColor: colorRed!,
        //colorText: Get.theme.snackBarTheme.actionTextColor
        colorText: colorLight);
  }

  static displayNormalSnackBar(title, message) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        //backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        backgroundColor: active!,
        //colorText: Get.theme.snackBarTheme.actionTextColor
        colorText: colorLight);
  }

  static displaySuccessSnackBar(title, message) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        //backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        backgroundColor: colorGreen!,
        //colorText: Get.theme.snackBarTheme.actionTextColor
        colorText: colorLight);
  }

  static String formatDateTime(String customFormat,
      {DateTime? dateTime, Timestamp? timestamp}) {
    var date = dateTime != null
        ? DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch)
        : DateTime.fromMicrosecondsSinceEpoch(
            timestamp!.microsecondsSinceEpoch);

    return DateFormat(customFormat).format(date);
  }

  ///
  /// Check Internet Connectivity
  ///

  static Future<bool> checkInternetConnection() async{
    return await InternetConnectionChecker().hasConnection;
  }



  ///
  /// @calledFrom used only for newOrder and existingOrder while adding newProduct to list
  ///
  ///

  static void showOrderMoreDetailsDialog(
      {ProductModel? model, OrderModel? orderModel, String? orderDocId, dialogHeight}) {
    var formKey = GlobalKey<FormState>();



    Get.defaultDialog(
      title: "Order More Details",
      titleStyle: headline4,
      content: Container(
        height:dialogHeight,
        width: 350,
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text:
                      "ProductName:  ${model != null ? model.productName : orderModel!.pName!}",
                  textStyle: bodyText1,
                ),
                const SizedBox(
                  height: 15,
                ),
                FormInputFieldWithIcon(
                  controller: orderController.productQtyController,
                  iconPrefix: Icons.shopping_cart,
                  labelText: 'Quantity',
                  iconColor: active!.withOpacity(0.85),
                  autofocus: false,
                  validator: Validator().notEmpty,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {},
                  onSaved: (value) => {},
                ),
                const SizedBox(
                  height: 15,
                ),
                FormInputFieldWithIcon(
                  controller: orderController.productBonusController,
                  iconPrefix: Icons.bolt,
                  labelText: 'Bonus',
                  iconColor: active!.withOpacity(0.85),
                  autofocus: false,
                  validator: Validator().notEmpty,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {},
                  onSaved: (value) => {},
                ),
                const SizedBox(
                  height: 15,
                ),
                FormInputFieldWithIcon(
                  controller: orderController.productExtraController,
                  iconPrefix: Icons.airline_seat_legroom_extra,
                  labelText: 'Extra',
                  iconColor: active!.withOpacity(0.85),
                  autofocus: false,
                  validator: Validator().notEmpty,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {},
                  onSaved: (value) => {},
                ),
                const SizedBox(
                  height: 15,
                ),
                FormInputFieldWithIcon(
                  controller: orderController.productNetController,
                  iconPrefix: Icons.timeline,
                  labelText: 'Net',
                  iconColor: active!.withOpacity(0.85),
                  autofocus: false,
                  validator: Validator().notEmpty,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {},
                  onSaved: (value) => {},
                ),
                const SizedBox(
                  height: 15,
                ),

                Visibility(
                  visible: customerController.customerModel!.areaCode == "0" || (orderModel!=null && orderModel.remarks!=null),
                  child: FormInputFieldWithIcon(
                    controller: orderController.productRemarksController,
                    iconPrefix: Icons.comment,
                    labelText: 'Remarks',
                    iconColor: active!.withOpacity(0.85),
                    autofocus: false,
                    validator: Validator().notEmpty,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) => {},
                    onSaved: (value) => {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onTap: () async {
                    if (model != null) {
                      model.isAddedToList = true;
                      if (orderDocId!.isNotEmpty && orderDocId != "") {
                        OrderModel orderModel = OrderModel(
                          pName: model.productName!,
                          pCode: model.productCode,
                          productAdditionDateTime: Timestamp.now(),
                          extra: orderController
                                  .productExtraController.text.isEmpty
                              ? "0"
                              : orderController.productExtraController.text,
                          bonus: orderController
                                  .productBonusController.text.isEmpty
                              ? "0"
                              : orderController.productBonusController.text,
                          orderQuantity:
                              orderController.productQtyController.text.isEmpty
                                  ? "0"
                                  : orderController.productQtyController.text,
                          net: orderController.productNetController.text.isEmpty
                              ? "0"
                              : orderController.productNetController.text,
                          remarks: orderController.productRemarksController.text,
                          orderBy: authController.userModel!.uid,

                        );
                        String customerID = customerController
                            .getCustomerById(orderDocId)
                            .code!;
                        orderController.addProductToExistingOrder(
                            customerID, orderModel);
                      } else {
                        orderController.addOrderProductToList(model);
                      }
                    } else {
                      orderController.updateOrderProductList(orderModel!);
                    }
                    Get.back();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  text: model != null ? "Add to List" : "Update",
                  width: 150,
                  height: 40,
                  color: active!,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showPasswordUpdateDialog(UserModel? userModel) {
    Get.defaultDialog(
        title: "Update Password",
        titleStyle: headline5,
        contentPadding: const EdgeInsets.all(30),
        content: Column(
          children: [
            kIsWeb
                ? CustomText(
                    text: "OldPassword: ${userModel!.password!}",
                    textStyle: caption,
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            FormPasswordInputFieldWithIcon(
              controller: authController.passwordController,
              iconPrefix: Icons.lock_rounded,
              iconColor: active!.withOpacity(0.85),
              labelText: 'Old Password',
              validator: Validator().password,
              obscureText: true,
              onChanged: (value) => {},
              maxLines: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            FormPasswordInputFieldWithIcon(
              controller: authController.newPasswordController,
              iconPrefix: Icons.lock_rounded,
              iconColor: active!.withOpacity(0.85),
              labelText: 'New Password',
              validator: Validator().password,
              obscureText: true,
              onChanged: (value) => {},
              maxLines: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              onTap: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                await authController.updateUserPassword(userModel!);
              },
              text: "Update",
              width: 150,
              height: 40,
              color: dark!,
            ),
          ],
        ),
        backgroundColor: Colors.white);
  }
}
