import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_constants.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/main.dart';
import 'package:ikram_enterprise/ui/mobile/profile/profile_ui.dart';
import 'package:ikram_enterprise/ui/mobile/widgets/circular_avatar.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
              child: const CustomText(
                text: "Profile",
                size: 24,
                weight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
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
            child: const ProfilesCommonData(),
          ),
        ),
      ],
    );
  }

}
