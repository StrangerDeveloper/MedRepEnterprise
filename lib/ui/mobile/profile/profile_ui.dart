import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/models/profile_avatars.dart';
import 'package:ikram_enterprise/ui/mobile/widgets/circular_avatar.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class ProfileUI extends StatelessWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: body(context),
      ),
    );
  }

  Widget body(context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            /// black background
            Positioned(
              top: 0,
              height: constraints.maxHeight * 0.3,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: active!,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)),
                ),
              ),
            ),

            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  /// Header
                  customHeader(),
                  SizedBox(height: constraints.maxHeight * 0.15),

                  const ProfilesCommonData()
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Profile',
              style: headline4.copyWith(color: colorLight),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilesCommonData extends StatelessWidget {
  const ProfilesCommonData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        ///profile pic & name & subscription for students
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///Profile icon with change icon
            Stack(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: active!.withOpacity(0.22),
                        offset: const Offset(0, 0),
                        blurRadius: 10.78,
                      ),
                    ],
                  ),
                  child: Obx(
                    () => CircularAvatar(
                      padding: 2,
                      radius: 50,
                      imageUrl: authController.userModel!.photoUrl!,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: InkWell(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Choose Profile Avatar",
                        barrierDismissible: false,
                        contentPadding: const EdgeInsets.all(kIsWeb ? 30 : 10),
                        titleStyle: headline4.copyWith(color: active!),
                        content: _profileIconsContent(),
                        onCancel: ()=>Get.back()
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              color: active!.withOpacity(0.3),
                              blurRadius: 10.78,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(Icons.add_a_photo, color: colorPurple),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            nameWidget(),
            const SizedBox(height: 15),
          ],
        ),

        /// card profile data, e.g. phone, email, address
        Obx(
          () => ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(5),
            children: authController
                .getProfileData()
                .map(
                  (profile) => profileCards(
                      profile["title"], profile["subtitle"], profile["icon"]),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: 20),

        /// logout button
        Center(
          child: CustomButton(
            width: 250,
            height: 45,
            onTap: () {
              authController.signOut();
              //Get.offAll(() => main());
              Phoenix.rebirth(context);
            },
            text: "Log out",
          ),
        ),
      ],
    );
  }

  Widget nameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 30),
        Align(
          alignment: Alignment.center,
          child: Obx(
            () => Text(
              authController.userModel!.name ?? 'ABC NAME',
              style: headline3,
            ),
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () => showEditDialog("name", authController.userModel!.name),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  color: active!.withOpacity(
                    0.3,
                  ),
                  blurRadius: 10.78,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child:
                  Icon(Icons.edit, size: 20, color: active!.withOpacity(0.8)),
            ),
          ),
        )
      ],
    );
  }

  Widget profileCards(title, subtitle, icon) {
    return Container(
      width: 290,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: active!.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.only(left: 30, top: 12, right: 30, bottom: 3),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
        title: Text(
          '$title',
          style: bodyText1.copyWith(color: Colors.black54),
        ),
        subtitle: Text(
          '$subtitle',
          style: bodyText1.copyWith(color: Colors.black87),
        ),
        //leading: SvgPicture.asset(icon),
        trailing: title.toLowerCase() == "email"
            ? null
            : InkWell(
                onTap: () => title.toLowerCase() == "password"
                    ? AppConstant.showPasswordUpdateDialog(
                        authController.userModel!)
                    : showEditDialog(title, subtitle),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: active!.withOpacity(0.8),
                ),
              ),
      ),
    );
  }

  void showEditDialog(title, subtitle) {
    authController.editTextFieldController.text = subtitle;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Get.defaultDialog(
      title: "Update $title",
      titleStyle: headline6,
      content: Form(
        key: formKey,
        child: FormInputFieldWithIcon(
          controller: authController.editTextFieldController,
          iconPrefix: Icons.title,
          labelText: title,
          autofocus: false,
          iconColor: active!.withOpacity(0.85),
          validator: title.toString().toLowerCase() == "phone"
              ? Validator().number
              : Validator().notEmpty,
          keyboardType: title.toString().toLowerCase() == "phone"
              ? TextInputType.phone
              : TextInputType.text,
          onChanged: (value) => {},
          onSaved: (value) => {},
        ),
      ),
      confirm: CustomButton(
        width: 80,
        height: 35,
        onTap: () async {
          if (formKey.currentState!.validate()) {
            SystemChannels.textInput
                .invokeMethod('TextInput.hide'); //to hide the keyboard - if any
            await authController.updateUserBuyTitle(title);
            Get.back();
          }
        },
        color: colorRed,
        text: "Update",
        textStyle: bodyText1.copyWith(color: colorLight),
      ),
    );
  }

  Widget _profileIconsContent() {
    debugPrint("ProfileAvatars ${authController.profileAvatarsList.length}");
    return Column(
      children: [
        Obx(
          () => GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children:
                List.generate(authController.profileAvatarsList.length, (index) {
              ProfileAvatars profileAvatar =
                  authController.profileAvatarsList[index];
              return InkWell(
                onTap: () {
                  authController.updateProfileAvatar(profileAvatar);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: active!.withOpacity(0.2),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      profileAvatar.url!,
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 10,),
         CustomText(text: "---* Pick from Gallery *---", textStyle: caption.copyWith(color:lightGrey,fontWeight: FontWeight.bold, fontSize: 9),),
        const SizedBox(height: 10,),
        Obx(()=> CustomText(text:authController.uploadingText.value, textStyle: caption.copyWith(color:colorGreen,),)),
        const SizedBox(height: 10,),
        CustomButton(
          width: 80,
          height: 35,
          onTap: () => authController.pickOrCaptureImageGallery(1),
          text: "Gallery",
        )

       /* Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              width: 80,
              height: 35,
              onTap: () => authController.pickOrCaptureImageGallery(0),
              text: "Camera",
            ),
            const SizedBox(width: 10,),

          ],
        ),*/
      ],
    );
  }
}
