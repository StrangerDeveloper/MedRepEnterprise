import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';

class PickProductsUI extends StatelessWidget {
  const PickProductsUI({Key? key, this.existingOrderDocID}) : super(key: key);
  final String? existingOrderDocID;
  @override
  Widget build(BuildContext context) {
    var dialogHeight =  MediaQuery.of(context).size.height * 0.5;
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.center,
          child: CustomText(
            text: "Pick Products",
            textStyle: headline3,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: FormInputFieldWithIcon(
            controller: orderController.productSearchController,
            iconPrefix: Icons.search,
            labelText: 'Search Product',
            hint: "Search by Product Name/Code or Company Name/Code",
            iconColor: active!,
            autofocus: false,
            textStyle: bodyText1,
            keyboardType: TextInputType.text,
            onChanged: (value) => {

              productController.getMedRepUser()
                  ? productController.handleMedRepProductSearch(value)
                  : productController.handleProductSearch(value),

              //SystemChannels.textInput.invokeMethod('TextInput.hide'),
            },
            onSaved: (value) => {},
          ),
        ),
        Obx(
          () => productController.productSearchList.isEmpty
              ? const Center(
                  child: CustomText(
                    text: "Search Product using Search Box ...",
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: productController.productSearchList.length,
                    itemBuilder: (_, index) {
                      ProductModel model =
                          productController.productSearchList[index];
                      //To check for keyboard visibility
                      var keyVisible = MediaQuery.of(context).viewInsets.bottom;

                      return CustomContainer(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          onTap: () => onPressAction(model, dialogHeight),
                          leading: model.isAddedToList != null &&
                                  model.isAddedToList!
                              ? Icon(
                                  Icons.done,
                                  color: colorGreen,
                                )
                              : IconButton(
                                  onPressed: () => onPressAction(model,dialogHeight),
                                  icon: Icon(
                                    Icons.add_circle_outlined,
                                    color: active!,
                                    size: 35,
                                  ),
                                ),
                          title: CustomText(
                            text: model.productName,
                            textStyle: headline6,
                          ),
                          subtitle: CustomText(
                            text: "Company: ${model.companyName}",
                            textStyle: bodyText3.copyWith(
                                fontWeight: FontWeight.normal),
                          ),
                          trailing: CustomText(
                            text: "Code: ${model.productCode}",
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

  void onPressAction(ProductModel model, dialogHeight) {
    if (!model.isAddedToList!) {
      if( customerController.customerModel!.areaCode == "0" ){
        dialogHeight = dialogHeight -80;
      }
      AppConstant.showOrderMoreDetailsDialog(model: model, orderDocId: existingOrderDocID!,dialogHeight: dialogHeight);
    } else {
      AppConstant.displayFailedSnackBar(
          "Product alert", "This product already added to list");
    }
  }
}
