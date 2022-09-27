import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/models/user_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_password_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class StaffPage extends StatelessWidget {
  const StaffPage({Key? key}) : super(key: key);

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
                    onTap: () => showAddStaffDialog(context),
                    text: "Add Staff",
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
                            maxCrossAxisExtent: 300,
                            //  childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: authController.staffList.length,
                    itemBuilder: (_, index) {
                      UserModel userModel = authController.staffList[index];
                      return singleGridChild(userModel);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget singleGridChild(UserModel userModel) {
    return CustomContainer(
      onTap: () {},
      hasOuterShadow: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => showStaffDetails(userModel),
                icon: Icon(
                  Icons.info_outline,
                  color: active!,
                ),
              ),
              IconButton(
                onPressed: () =>
                    AppConstant.showPasswordUpdateDialog(userModel),
                icon: Icon(
                  Icons.password,
                  color: dark!,
                ),
              ),
              IconButton(
                onPressed: () => showUpdateStaffDialog(userModel),
                icon: Icon(
                  Icons.edit,
                  color: dark!,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Delete Attention",
                    titleStyle: headline6,
                    backgroundColor: Colors.white,
                    content: CustomText(
                      text: "Do you really wants to delete ${userModel.name} ?",
                      textStyle: bodyText1,
                    ),
                    confirm: CustomButton(
                      width: 80,
                      height: 35,
                      onTap: () => authController.deleteUser(userModel),
                      color: colorRed,
                      text: "Delete",
                      textStyle: bodyText1.copyWith(color: colorLight),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: colorRed!,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(userModel.photoUrl!),
            radius: 35,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            userModel.name!,
            style: headline5.copyWith(color: active!),
          ),
          Text(
            userModel.email!,
            style: bodyText2,
          ),
          Text(
            userModel.phone!,
            style: bodyText2,
          ),
          Text(
            userModel.address!,
            style: bodyText2,
          ),
          /*userModel.userType!.toLowerCase().contains("medical representative")
              ? userCompanies(userModel)
              :*/
          Text(
            userModel.userType!,
            style: bodyText2.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  void showAddStaffDialog(context) {
    Get.defaultDialog(
        title: "Add Staff",
        titleStyle: headline2,
        content: _bottomSheetContents(),
        backgroundColor: Colors.white);
  }

  void showUpdateStaffDialog(UserModel userModel) {
    Get.defaultDialog(
        title: "Update ${userModel.name}",
        titleStyle: headline2,
        content: _updateBottomSheetContents(userModel),
        backgroundColor: Colors.white);
  }

  Widget _bottomSheetContents() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var error = false.obs;

    return Container(
      width: 400,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Staff Type dropdown,
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: active!, width: 1.5, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton(
                    isExpanded: true,
                    //style: AppThemes.normalBlackFont,
                    hint: Text('{${authController.selectedType.value}'),
                    onChanged: (newValue) {
                      authController.setType(newValue as String);
                    },
                    items: authController.staffTypeList.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          '$type',
                          style: bodyText1,
                        ),
                      );
                    }).toList(),
                    value: authController.selectedType.value,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              ///Assign Medical a Company code
              Obx(
                () => Visibility(
                  visible: authController.isMedicalRep.value,
                  child: FormInputFieldWithIcon(
                    controller: authController.companyCodeController,
                    iconPrefix: Icons.account_tree_outlined,
                    labelText: 'Company Code',
                    hint: "separate with comma if multiple e.g. 1,2,3,4",
                    iconColor: active!.withOpacity(0.75),
                    autofocus: false,
                    validator: Validator().notEmpty,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => {},
                    onSaved: (value) => {},
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              FormInputFieldWithIcon(
                controller: authController.nameController,
                iconPrefix: Icons.person,
                labelText: 'Name',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().name,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: authController.emailController,
                iconPrefix: Icons.email,
                labelText: 'Email',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormPasswordInputFieldWithIcon(
                controller: authController.passwordController,
                iconPrefix: Icons.lock_rounded,
                iconColor: active!.withOpacity(0.85),
                labelText: 'Password',
                validator: Validator().password,
                obscureText: true,
                onChanged: (value) => {},
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: authController.phoneController,
                iconPrefix: Icons.phone_android_rounded,
                labelText: 'Contact Number',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().number,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: authController.addressController,
                iconPrefix: Icons.location_on,
                labelText: 'Address',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().notEmpty,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(
                () => error.isTrue
                    ? Text(
                        "*Some Required are missing!",
                        style: caption.copyWith(color: colorRed!),
                      )
                    : const Text(""),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomButton(
                onTap: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if (formKey.currentState!.validate()) {
                    await authController.signUpWithEmailAndPassword();
                    error.value = false;
                    Get.back();
                  } else {
                    error.value = true;
                  }
                },
                text: "Submit",
                width: 150,
                height: 40,
                color: dark!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateBottomSheetContents(UserModel? userModel) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var error = false.obs;

    if (userModel != null) {
      authController.setType(userModel.userType!);
      authController.companyCodeController.text = userModel.companyCode!;
      authController.nameController.text = userModel.name!;
      authController.addressController.text = userModel.address!;
      authController.phoneController.text = userModel.phone!;
    }

    return Container(
      width: 400,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Staff Type dropdown,
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: active!, width: 1.5, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton(
                    isExpanded: true,
                    //style: AppThemes.normalBlackFont,
                    hint: Text(
                      '{${authController.selectedType.value}',
                    ),
                    onChanged: (newValue) {
                      authController.setType(newValue as String);
                    },
                    items: authController.staffTypeList.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          '$type',
                          style: bodyText1,
                        ),
                      );
                    }).toList(),
                    value: authController.selectedType.value,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              ///Assign Medical a Company code
              Obx(
                () => Visibility(
                  visible: authController.isMedicalRep.value,
                  child: FormInputFieldWithIcon(
                    controller: authController.companyCodeController,
                    iconPrefix: Icons.account_tree_outlined,
                    labelText: 'Company Code',
                    hint: "separate with comma if multiple e.g. 101,102",
                    iconColor: active!.withOpacity(0.75),
                    autofocus: false,
                    validator: Validator().notEmpty,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => {},
                    onSaved: (value) => {},
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              FormInputFieldWithIcon(
                controller: authController.nameController,
                iconPrefix: Icons.person,
                labelText: 'Name',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().name,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: authController.phoneController,
                iconPrefix: Icons.phone_android_rounded,
                labelText: 'Contact Number',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().number,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: authController.addressController,
                iconPrefix: Icons.location_on,
                labelText: 'Address',
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().notEmpty,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(
                () => error.isTrue
                    ? Text(
                        "*Some Required are missing!",
                        style: caption.copyWith(color: colorRed!),
                      )
                    : const Text(""),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomButton(
                onTap: () async {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  if (formKey.currentState!.validate()) {
                    userModel!.userType = authController.selectedType.value;
                    userModel.name = authController.nameController.text;
                    userModel.address = authController.addressController.text;
                    userModel.phone = authController.phoneController.text;
                    userModel.companyCode =
                        authController.companyCodeController.text;
                    await authController.updateUser(userModel);
                    error.value = false;
                    Get.back();
                  } else {
                    error.value = true;
                  }
                },
                text: "Update",
                width: 150,
                height: 40,
                color: dark!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showStaffDetails(UserModel userModel) {
    Get.defaultDialog(
        title: "Details of ${userModel.name}",
        titleStyle: headline2,
        content: _staffDetailsContents(userModel),
        backgroundColor: Colors.white);
  }

  Widget _staffDetailsContents(UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CustomText(
              text: userModel.name!,
              textStyle: headline3.copyWith(color: active!)),
        ),
        _textWidget("Email", userModel.email!),
        _textWidget("Phone", userModel.phone!),
        _textWidget("Address", userModel.address!),
        _textWidget("Type", userModel.userType!),
        userModel.userType!.toLowerCase().contains("medical representative")
            ? userCompanies(userModel)
            : Container()
      ],
    );
  }

  _textWidget(title, value) {
    return RichText(
        text: TextSpan(
      children: [
        TextSpan(text: "$title: ", style: bodyText2),
        TextSpan(
            text: value,
            style: bodyText2.copyWith(fontWeight: FontWeight.w700)),
      ],
    ));
  }

  userCompanies(UserModel userModel) {
    List<String> companyCode = userModel.companyCode!.split(",");
    StringBuffer buffer = StringBuffer();

    for (var value in companyCode) {
      buffer.write(productController.getCompanyByCode(value.trim()));
      buffer.write(" , ");
    }
    return Text(
      "Companies: ${buffer.toString()}",
      textAlign: TextAlign.center,
      style: bodyText2.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
