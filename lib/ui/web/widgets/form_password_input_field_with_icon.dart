import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';

class FormPasswordInputFieldWithIcon extends StatefulWidget {
  const FormPasswordInputFieldWithIcon(
      {Key? key,
      required this.controller,
      required this.iconPrefix,
      required this.labelText,
      required this.validator,
      this.iconColor,
      this.textStyle,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.maxLength,
      this.maxLengthEnforcement,
      this.onPasswordVisible,
      required this.onChanged,
      this.onSaved})
      : super(key: key);

  final TextEditingController controller;
  final IconData iconPrefix;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool? obscureText;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final Color? iconColor;
  final TextStyle? textStyle;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final void Function(String) onChanged;
  final void Function(String?)? onSaved;
  final void Function(bool?)? onPasswordVisible;

  @override
  State<FormPasswordInputFieldWithIcon> createState() =>
      _FormPasswordInputFieldWithIconState();
}

class _FormPasswordInputFieldWithIconState
    extends State<FormPasswordInputFieldWithIcon> {
  RxBool passVisibility = true.obs;

  _toggle() {
    passVisibility.value = !passVisibility.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        decoration: InputDecoration(
            filled: false,
            prefixIcon: Icon(
              widget.iconPrefix,
              color: widget.iconColor!,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.iconColor!,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            fillColor: widget.iconColor!,
            labelText: widget.labelText,
            labelStyle: widget.textStyle?? bodyText1,
            focusColor: widget.iconColor!,
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: widget.iconColor ?? active!, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: widget.obscureText!
                ? GestureDetector(
                    onTap: _toggle,
                    child: Icon(
                      passVisibility.isTrue
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: widget.iconColor,
                    ),
                  )
                : null),
        controller: widget.controller,
        cursorColor: widget.iconColor,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        obscureText: passVisibility.value,
        style: widget.textStyle ?? bodyText1,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLength: widget.maxLength,
        validator: widget.validator,
      ),
    );
  }
}
