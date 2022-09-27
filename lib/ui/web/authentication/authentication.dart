import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_password_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    authController.setBtnState(0);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image.asset("assets/icons/logo.png", width: 150, height: 150,),
                      ),
                      //Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      CustomText(
                        text: "Welcome back to the Ikram Enterprise",
                        color: dark!,
                      ),
                      CustomText(
                        text: "${kIsWeb ? "Admin" : "Staff"} Panel",
                        color: dark!,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'Email',
                    iconColor: active!,
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
                    iconColor: active!,
                    labelText: 'Password',
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => {},
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child:
                          CustomText(text: "Forgot password?", color: active!)),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => Center(child: _setupButton())),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _setupButton() {
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
        onTap: () => authController.loginWithEmailAndPassword(), text: "Login");
  }
}
