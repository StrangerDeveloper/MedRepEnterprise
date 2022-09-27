import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/models/area_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class AreasPage extends StatelessWidget {
  const AreasPage({Key? key}) : super(key: key);

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
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onTap: () => showAreaDialog(calledFor: 0),
                    text: "Add Area",
                    width: 150,
                    height: 45,
                    color: dark!,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: areaController.areasList.length,
                    itemBuilder: (_, index) {
                      AreaModel model = areaController.areasList[index];
                      return CustomContainer(
                          child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "# ${model.areaCode}",
                                  textStyle:
                                      headline5.copyWith(color: lightGrey),
                                ),
                                CustomText(
                                  text: model.areaName,
                                  textStyle:
                                      headline6.copyWith(color: colorGreen),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => showAreaDialog(
                                      calledFor: 1, model: model),
                                  icon: Icon(
                                    Icons.edit,
                                    color: dark!,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => showDeleteDialog(model),
                                  icon: Icon(
                                    Icons.delete,
                                    color: colorRed!.withOpacity(0.8),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// @calledFor
  /// 1 is for edit
  ///
  void showAreaDialog({calledFor, AreaModel? model}) {
    Get.defaultDialog(
        title: "${calledFor > 0 ? "Update" : "Add"} Area",
        titleStyle: headline2,
        content: _dialogContents(calledFor, areaModel: model),
        backgroundColor: Colors.white);
  }

  Widget _dialogContents(calledFor, {AreaModel? areaModel}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    if (calledFor == 1 && areaModel != null) {
      areaController.areaCodeController.text = areaModel.areaCode!;
      areaController.areaNameController.text = areaModel.areaName!;
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            FormInputFieldWithIcon(
              controller: areaController.areaCodeController,
              iconPrefix: Icons.numbers,
              labelText: 'Code',
              hint: "1001",
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().notEmpty,
              keyboardType: TextInputType.text,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 15,
            ),
            FormInputFieldWithIcon(
              controller: areaController.areaNameController,
              iconPrefix: Icons.location_city,
              labelText: 'Area Name',
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().notEmpty,
              keyboardType: TextInputType.text,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              onTap: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                if (formKey.currentState!.validate()) {
                  if (calledFor == 1) {
                    areaModel!.areaCode =
                        areaController.areaCodeController.text;
                    areaModel.areaName = areaController.areaNameController.text;
                    areaController.updateArea(areaModel);
                  } else {
                    await areaController.createArea();
                  }
                  Get.back();
                }
              },
              text: calledFor == 1 ? "Update" : "Add",
              width: 150,
              height: 40,
              color: active!,
            ),
          ],
        ),
      ),
    );
  }

  showDeleteDialog(AreaModel model) {
    Get.defaultDialog(
        title: "Delete Attention",
        titleStyle: headline6,
        backgroundColor: Colors.white,
        content: CustomText(
            text: "Do you really wants to delete ${model.areaName} ?",
            textStyle: bodyText1),
        confirm: CustomButton(
          width: 80,
          height: 35,
          onTap: () => areaController.deleteArea(model),
          color: colorRed,
          text: "Delete",
          textStyle: bodyText1.copyWith(color: colorLight),
        ));
  }
}
